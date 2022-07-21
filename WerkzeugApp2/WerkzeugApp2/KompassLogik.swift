//
//  KompassLogik.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 02.07.22.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI

class KompassLogik: NSObject, ObservableObject, CLLocationManagerDelegate {
    var objectWillChange = PassthroughSubject<Void, Never>()
    var degrees: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    var speed: Double = .zero {
        didSet {
            objectWillChange.send()
        }
    }
    
    private let locationManager: CLLocationManager
   
    
    override init() {
        self.locationManager = CLLocationManager()
           
        super.init()
        self.locationManager.delegate = self
        self.setup()
    }
    
    private func setup() {
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let latestLocation: AnyObject = locations[locations.count - 1]
        speed = latestLocation.speed
        print("didUpdateLocations: \(latestLocation)")
    }
    
    func locationManager (_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.degrees = -1 * newHeading.magneticHeading
        print("didUpdateHeading:")
    }
    
}
