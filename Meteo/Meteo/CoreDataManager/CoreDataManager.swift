//
//  CoreDataManager.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData


class CoreDataManager {
    private static weak var currentInstance: CoreDataManager?
    private weak var privateBackgroundContext: NSManagedObjectContext?
    let persistentContainer: NSPersistentContainer!

    static var current: CoreDataManager {
        get {
            if let instance = self.currentInstance {
                return instance
            } else {
                return CoreDataManager()
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        get {
            return self.persistentContainer.viewContext
        }
    }

    var backgroundContext: NSManagedObjectContext {
        guard let privateBackgroundContext = privateBackgroundContext else {
            let newBackgroundContext = self.persistentContainer.newBackgroundContext()
            self.privateBackgroundContext = newBackgroundContext
            return newBackgroundContext
        }

        return privateBackgroundContext
    }

    // MARK: - Init

    init(container: NSPersistentContainer) {
        self.persistentContainer = container
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }

    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }

    // MARK: - Actions

    func save(_ meteoDTO: MeteoDTO, coordinate: CLLocationCoordinate2D, isCurrentLocation: Bool, _ completion: @escaping(Result<Void, Error>) -> Void) {
        self.persistentContainer.performBackgroundTask { (context) in
            do {
                let fetchRequest = Location.fetchRequestCurrentLocation()
                if let location = try context.fetch(fetchRequest).first {
                    context.delete(location)
                }

                let location = Location(context: context)
                location.a_latitude = coordinate.latitude
                location.a_longitude = coordinate.longitude
                location.is_current_location = isCurrentLocation

                meteoDTO.forecast.forEach({ (forecastDTO) in
                    let forecast = self.addForecast(forecastDTO, context: context)
                    location.addToR_localisation(forecast)
                })

            } catch {
                completion(.failure(error))
            }

            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }

        }
    }

    private func addForecast(_ forecastDTO: ForecastDTO, context: NSManagedObjectContext) -> Forecast {
        let forecast = Forecast(context: context)
        forecast.a_date = forecastDTO.date as NSDate
        forecast.a_humidity = forecastDTO.humidity.twoMeter!
        forecast.a_windSpeed = forecastDTO.windSpeed.tenMeter!
        forecast.a_windDirection = forecastDTO.windDirection.tenMeter!
        forecast.a_temperature = forecastDTO.temperature.ground!
        forecast.a_cloudiness = forecastDTO.cloudiness.totale!
        return forecast
    }
}
