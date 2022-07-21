//
//  MotionDetector.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 03.07.22.
//

import CoreMotion
import UIKit

//used for Wasserwaage & Seismometer
class MotionDetector: ObservableObject {
    private let motionManager = CMMotionManager()
    
    private var timer = Timer()
    private var updateInterval: TimeInterval
    
    //Drehung(roll) und Neigung(pitch)
    @Published var pitch: Double = 0
    @Published var roll: Double = 0
    //einzelne Beschleunigungen an den Achsen
    @Published var xAcceleration: Double = 0
    @Published var yAcceleration: Double = 0
    @Published var zAcceleration: Double = 0
    
    
    //Schrittzähler
    private let pedometer: CMPedometer = CMPedometer()
    @Published var steps: Int? = nil
    
    //Hilfsfunktion zur Überprüfung ob Schrittzähler verfügbar ist
    private var isPedometerAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() &&
        CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    private func startPedometer() {
        if isPedometerAvailable {
            pedometer.startUpdates(from: Date()) {(data, error) in
                guard let data = data, error == nil else {return}
                self.steps = data.numberOfSteps.intValue
            }
        } else {
            print("Dieses Gerät verfügt nicht über die benötigten Schrittzähler Daten.")
        }
    }
    
    //Geschwindigkeit aus Beschleunigung (Acceleration) ausrechnen
    let accelerometerFreq = 50.0
    let filteringFactor = 0.1
    
    var speedX: Double = 0.0
    var speedY: Double = 0.0
    var speedZ: Double = 0.0
    @Published var prevVelocity: Double = 0.0
    var prevAcceleration: Double = 0.0
    var prevTime: TimeInterval = CACurrentMediaTime()
    
    func accelerometer() {
        let currentTime = CACurrentMediaTime()
        
        //Gesamtbeschleunigung ausrechnen? anderer Ansatz?
        //let vector: Double = sqrt(pow(xAcceleration,2)+pow(yAcceleration,2)+pow(zAcceleration, 2))
        //let currentAcceleration: Double = vector - prevVelocity
        //let velocity: Double = (currentAcceleration + prevAcceleration)/2 * (prevTime - currentTime) + prevVelocity
        
        // v = a * t + v0
        // geschw. = beschl. * zeit + anfangsgeschw.
        // zeit = zeitinterval zw. aktueller Zeit und letzter Messung
        
        /*
        print(round(xAcceleration * 100) / 100.0)
        print(round(yAcceleration * 100) / 100.0)
        print(round(zAcceleration * 100) / 100.0)
        print("---------------")
        */
        
        let roundedXAcc = round(xAcceleration * 100) / 100.0
        let roundedYAcc = round(yAcceleration * 100) / 100.0
        let roundedZAcc = round(zAcceleration * 100) / 100.0
        
        if roundedXAcc == 0.00 || roundedXAcc == 0.01 {
            speedX = 0.00
        } else {
            speedX = (xAcceleration * (currentTime - prevTime)) + speedX
        }
        if roundedYAcc == 0.00 || roundedYAcc == 0.01 {
            speedY = 0.00
        } else {
            speedY = (yAcceleration * (currentTime - prevTime)) + speedY
        }
        if roundedYAcc == 0.00 || roundedZAcc == 0.01 {
            speedZ = 0.00
        } else {
            speedZ = (zAcceleration * (currentTime - prevTime)) + speedZ
        }
        
        speedX = (xAcceleration * (currentTime - prevTime)) + speedX
        speedY = (yAcceleration * (currentTime - prevTime)) + speedY
        speedZ = (zAcceleration * (currentTime - prevTime)) + speedZ
        
        /*
        print(speedX)
        print(speedY)
        print(speedZ)
        print("---------------")
        */
        
        let tempVelo = (speedX+speedY+speedZ)/3
        
        if speedX == 0.0 && speedY == 0.0 && speedZ == 0.0 {
            prevVelocity = 0.00
        } else {
            if (tempVelo < 0) {
                prevVelocity = prevVelocity + (tempVelo * -1)
            }else {
                prevVelocity = prevVelocity + tempVelo
            }
        }
        
        prevTime = currentTime
        
        //prevAcceleration = currentAcceleration
    }
    
    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol? = nil
    let notification = UIDevice.orientationDidChangeNotification
    
    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    func start() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()
            startPedometer()
            
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("Dieses Gerät verfügt nicht über die benötigten Daten.")
        }
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        orientationObserver = NotificationCenter.default.addObserver(
            forName: notification, object: nil, queue: .main) { [weak self] _ in
                switch UIDevice.current.orientation {
                case .faceUp, .faceDown, .unknown:
                    break
                default:
                    self?.currentOrientation = UIDevice.current.orientation
                }
            }
    }
    
    func updateMotionData() {
        if let data = motionManager.deviceMotion {
            (roll, pitch) = currentOrientation.adjustedRollAndPitch(data.attitude)
            xAcceleration = data.userAcceleration.x
            yAcceleration = data.userAcceleration.y
            zAcceleration = data.userAcceleration.z
            accelerometer()
        }
    }
     
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver, name: notification,  object: nil)
        }
        orientationObserver = nil
    }
    
    deinit {
        stop()
    }
    
}

extension MotionDetector {
    func started() -> MotionDetector {
        start()
        return self
    }
}

//Hilfsfunktion um roll&pitch jeh nach Smartphone-Haltung richtig wiederzugeben
extension UIDeviceOrientation {
    func adjustedRollAndPitch(_ attitude: CMAttitude) -> (roll: Double, pitch: Double) {
        switch self {
        case .unknown, .faceUp, .faceDown:
            return (attitude.roll, -attitude.pitch)
        case .landscapeLeft:
            return (attitude.pitch, -attitude.roll)
        case .portrait:
            return (attitude.roll, attitude.pitch)
        case .portraitUpsideDown:
            return (-attitude.roll, -attitude.pitch)
        case .landscapeRight:
            return (-attitude.pitch, attitude.roll)
        @unknown default:
            return (attitude.roll, attitude.pitch)
        }
    }
}

