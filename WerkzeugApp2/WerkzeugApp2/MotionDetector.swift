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

    @Published var neigung: Double = 0
    @Published var drehung: Double = 0
    @Published var zBeschleunigung: Double = 0
    
    //speichert Code, der ausgeführt werden würde, wenn sich die MotionData ändert
    var onUpdate: (() -> Void) = {}
    
    private var currentOrientation: UIDeviceOrientation = .landscapeLeft
    private var orientationObserver: NSObjectProtocol? = nil
    let notification = UIDevice.orientationDidChangeNotification
    
    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    
    func start() {
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
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()
            
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                self.updateMotionData()
            }
        } else {
            print("Dieses Gerät verfügt nicht über die benötigten Daten.")
        }
                
    }
    /*
    func updateMotionData() {
        if let data = motionManager.deviceMotion {
            (drehung, neigung) = currentOrientation.adjustedRollAndPitch(data.attitude)
            zBeschleunigung = data.userAcceleration.z
            
            onUpdate()
        }
    }
     */
    
}

