//
//  LocationManager.swift
//  WeatherLocation
//
//  Created by Evgeniy Levin on 8/9/19.
//  Copyright © 2019 Evgeniy Levin. All rights reserved.
//

import Foundation
import CoreLocation

final class AppLocationManager: NSObject {
    
    static let shared = AppLocationManager()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var locationChanged: ((CLLocation) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
    }
    
    var isServiceEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var isAuthorized: Bool {
        guard isServiceEnabled else {
            return false
        }
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            return false
        default:
            return true
        }
    }
}

extension AppLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
        if let currentLocation = locations.last {
            
            locationChanged?(currentLocation)
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager status \(status)")
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startMonitoringSignificantLocationChanges()
        default:
            print("Not allowed \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Location manager error \(error)")
    }
}
