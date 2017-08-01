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

protocol LocationManagerDelegate: class {
    func obtainCoordinates(_ coordinate: Coordinate)
    func failedWithError(_ error: LocationError)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    weak var permissionDelegate: LocationPermissionsDelegate?
    weak var delegate: LocationManagerDelegate?
    
    init(delegate: LocationManagerDelegate?, permissionsDelagate: LocationPermissionsDelegate?) {
        self.delegate = delegate
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
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionDelegate?.authorizationSucceeded()
        } else {
            permissionDelegate?.authorizationFailedWithStatus(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            delegate?.failedWithError(.unkownError)
            return
        }
        switch error.code {
        case .locationUnknown, .network:
            delegate?.failedWithError(.unableToFindLocation)
        case .denied:
            delegate?.failedWithError(.disallowedByUser)
        default:
            return
        }
    }
}
