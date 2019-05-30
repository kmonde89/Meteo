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
    var coordinate = KVObservable<CLLocationCoordinate2D?>(nil)

    override init() {
        super.init()
        self.locationManager = LocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.getAuthorizationStatus()
        self.performFetch()
    }


    func performFetch() {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
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
                guard let coordinate = self?.coordinate.value else {
                    return
                }
                CoreDataManager.current.save(meteoDTO, coordinate: coordinate, isCurrentLocation: true, { result in
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

extension ForecastListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let controller = controller as? NSFetchedResultsController<Forecast> {
            self.forecasts.value = controller.fetchedObjects ?? []
        }
    }
}
