//
//  ForecastListViewModel.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

class ForecastListViewModel {
    private var getMeteo: GetMeteo

    var errorClosure: ((Error) -> Void)?
    var forecasts = KVObservable<[ForecastDTO]>([])

    init(localisation: String) {
        self.getMeteo = GetMeteo(location: localisation)
    }

    func reloadInformations() {
        self.getMeteo.performRequest { [weak self](result) in
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

