//
//  LocationManager.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    enum AuthorizationStatus {
        case authorized
        case unauthorized
        case undetermined
    }

    private let locationManager = CLLocationManager()
    var delegate: LocationManagerDelegate?

    var location: CLLocation? {
        return locationManager.location
    }

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func getAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            self.delegate?.authorization(status: .authorized)
        case .notDetermined:
            self.delegate?.authorization(status: .undetermined)
        default:
            self.delegate?.authorization(status: .unauthorized)
        }
    }

    func requestAutorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    func getPlace(for location: CLLocation, completion: @escaping (Result<CLPlacemark?, Error>) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(placemarks?.first))
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.delegate?.authorizationDidChange(status: .authorized)
        case .notDetermined:
            self.delegate?.authorizationDidChange(status: .undetermined)
        default:
            self.delegate?.authorizationDidChange(status: .unauthorized)
        }
    }
}

protocol LocationManagerDelegate {
    func authorizationDidChange(status: LocationManager.AuthorizationStatus)
    func authorization(status: LocationManager.AuthorizationStatus)
}
