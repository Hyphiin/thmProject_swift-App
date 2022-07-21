//
//  TachometerLogik.swift
//  WerkzeugApp2
//
//  Created by FMA2 on 17.07.22.
//

import Foundation
import Combine
import CoreLocation

class TachometerLogik: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var objectWillChange = PassthroughSubject<Void, Never>()
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
        self.locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ){
        print("didUpdateLocations: \(locations)")
    }
     
}
