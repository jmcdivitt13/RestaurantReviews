//
//  LocationManager.swift
//  RestaurantReviews
//
//  Created by Jeff Ripke on 7/31/17.
//  Copyright © 2017 Jeff Ripke. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case unkownError
    case disallowedByUser
    case unableToFindLocation
}

protocol LocationPermissionsDelegate: class {
    func authorizationSucceeded()
    func authorizationFailedWithStatus(_ status: CLAuthorizationStatus)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    weak var permissionDelegate: LocationPermissionsDelegate?
    
    init(permissionsDelagate: LocationPermissionsDelegate?) {
        self.permissionDelegate = permissionsDelagate
        super.init()
        manager.delegate = self
    }
    
    func requestLocationAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionDelegate?.authorizationSucceeded()
        } else {
            permissionDelegate?.authorizationFailedWithStatus(status)
        }
    }
}
