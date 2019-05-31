//
//  ForecastListViewModel.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class ForecastListViewModel: NSObject {
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Forecast>? = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Forecast> = Forecast.fetchRequestCurrentLocationForecast()

        // Create Fetched Results Controller

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.current.viewContext, sectionNameKeyPath: nil, cacheName: nil)


        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    // MARK: - Requests

    private var getMeteo: GetMeteo? {
        didSet {
            guard let dataTask = oldValue?.dataTask, dataTask.state == .running else {
                return
            }

            dataTask.suspend()
            self.reloadInformations()
        }
    }

    // MARK: - Manager

    private var locationManager: LocationManager?

    // MARK: - Closure

    var errorClosure: ((Error) -> Void)?

    // MARK: - Observable

    var forecasts = KVObservable<[Forecast]>([])
    var location = KVObservable<CLLocation?>(nil)
    var locality = KVObservable<String?>(nil)

    override init() {
        super.init()
        self.locationManager = LocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.getAuthorizationStatus()
        self.performFetch()
    }

    // MARK: - Actions

    func performFetch() {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }

    func suspendRunningRequest() {
        guard let dataTask = self.getMeteo?.dataTask, dataTask.state == .running else {
            return
        }

        dataTask.suspend()
    }

    func updateGetMeteoLocation() {
        guard let location = self.location.value else {
            return
        }

        self.getMeteo = GetMeteo(location: "\(location.coordinate.latitude),\(location.coordinate.longitude)")
        self.locationManager?.getPlace(for: location, completion: { [weak self]result in
            switch result {
            case .success(let placemark):
                self?.locality.value = placemark?.locality
            case .failure(let error):
                self?.errorClosure?(error)
            }
        })
    }

    func reloadInformations() {
        self.getMeteo?.performRequest { [weak self](result) in
            switch result {
            case .success(let meteoDTO):
                guard let location = self?.location.value else {
                    return
                }
                CoreDataManager.current.save(meteoDTO, coordinate: location.coordinate, isCurrentLocation: true, { result in
                    DispatchQueue.main.async { [weak self] in
                        switch result {
                        case .failure(let error):
                            self?.errorClosure?(error)
                        default:
                            return
                        }
                    }
                })
            case .failure(let error):
                self?.errorClosure?(error)
            }
        }
    }

    func forecastCount() -> Int? {
        return self.fetchedResultsController?.fetchedObjects?.count
    }

    func forecastModel(at indexPath: IndexPath) -> Forecast? {
        return self.fetchedResultsController?.object(at: indexPath)
    }
}

extension ForecastListViewModel: LocationManagerDelegate {
    func authorizationDidChange(status: LocationManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self.location.value = self.locationManager?.location
        case .unauthorized:
            self.locationManager?.requestAutorization()
        case .undetermined: return
        }
    }

    func authorization(status: LocationManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self.location.value = self.locationManager?.location
        case .unauthorized, .undetermined:
            self.locationManager?.requestAutorization()
        }
    }
}

extension ForecastListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let controller = controller as? NSFetchedResultsController<Forecast> {
            self.forecasts.value = controller.fetchedObjects ?? []
        }
    }
}
