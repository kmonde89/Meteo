//
//  ForecastListViewModel.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import CoreLocation

class ForecastListViewModel {
    private var getMeteo: GetMeteo? {
        didSet {
            guard let dataTask = oldValue?.dataTask, dataTask.state == .running else {
                return
            }

            dataTask.suspend()
            self.reloadInformations()
        }
    }

    private var locationManager: LocationManager?

    var errorClosure: ((Error) -> Void)?

    // MARK: - Observable

    var forecasts = KVObservable<[ForecastDTO]>([])
    var coordinate = KVObservable<CLLocationCoordinate2D?>(nil)

    init(localisation: String) {
        self.getMeteo = GetMeteo(location: localisation)
    }

    init() {
        self.locationManager = LocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.getAuthorizationStatus()
    }


    func updateGetMeteoLocation() {
        guard let coordinate = self.coordinate.value else {
            return
        }

        self.getMeteo = GetMeteo(location: "\(coordinate.latitude),\(coordinate.longitude)")
    }

    func reloadInformations() {
        self.getMeteo?.performRequest { [weak self](result) in
            switch result {
            case .success(let meteoDTO):
                self?.forecasts.value = meteoDTO.forecast.sorted(by: {$0.date < $1.date})
            case .failure(let error):
                self?.errorClosure?(error)
            }
        }
    }

    func forecast(for row: Int) -> ForecastDTO? {
        guard row > -1 && row < self.forecasts.value.count else {
            return nil
        }

        return self.forecasts.value[row]
    }
}

extension ForecastListViewModel: LocationManagerDelegate {
    func authorizationDidChange(status: LocationManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self.coordinate.value = self.locationManager?.location?.coordinate
        case .unauthorized:
            self.locationManager?.requestAutorization()
        case .undetermined: return
        }
    }

    func authorization(status: LocationManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self.coordinate.value = self.locationManager?.location?.coordinate
        case .unauthorized, .undetermined:
            self.locationManager?.requestAutorization()
        }
    }
}

