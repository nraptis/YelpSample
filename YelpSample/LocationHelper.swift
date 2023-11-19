//
//  LocationHelper.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import Foundation
import CoreLocation

protocol LocationHelperDelegate: AnyObject {
    func locationDidFail()
    func locationDidUpdate(lat: Double, lng: Double)
}

class LocationHelper: NSObject {
    let coreLocationManager = CLLocationManager()
    
    weak var delegate: LocationHelperDelegate?
    override init() {
        super.init()
    }
    
    func fetch() {
        coreLocationManager.delegate = self
        coreLocationManager.requestWhenInUseAuthorization()
    }
}

extension LocationHelper: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            DispatchQueue.main.async {
                self.delegate?.locationDidUpdate(lat: lat, lng: lng)
            }
            
        } else {
            DispatchQueue.main.async {
                self.delegate?.locationDidFail()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch coreLocationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.coreLocationManager.requestLocation()
        default:
            DispatchQueue.main.async {
                self.delegate?.locationDidFail()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.locationDidFail()
        }
    }
}
