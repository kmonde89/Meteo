//
//  ForecastListViewController.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import UIKit
import CoreLocation

class ForecastListViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var forecastsObserver: KVObserver<[ForecastDTO]>?
    var coordinateObserver: KVObserver<CLLocationCoordinate2D?>?
    let viewModel = ForecastListViewModel()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        ForecastTableViewCell.cellRegistration(on: self.tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.bind(viewModel)
        self.viewModel.reloadInformations()
    }


    // MARK: - Binding

    func bind(_ viewModel: ForecastListViewModel?) {
        guard let viewModel = viewModel else {
            return
        }

        let forecastsObserver = KVObserver<[ForecastDTO]>(viewModel.forecasts)

        forecastsObserver.closure = { [weak self ] _ in
            self?.tableView.reloadData()
        }
        self.forecastsObserver = forecastsObserver

        let coordinateObserver = KVObserver<CLLocationCoordinate2D?>(viewModel.coordinate)

        coordinateObserver.closure = { [weak self ] _ in
            self?.viewModel.updateGetMeteoLocation()
            self?.viewModel.reloadInformations()
        }
        self.coordinateObserver = coordinateObserver

        viewModel.errorClosure = { [weak self] error in
            self?.show(error: error)
        }
    }

}

extension ForecastListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastsObserver?.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ForecastTableViewCell.dequeueCell(from: tableView, for: indexPath)

        if let forecast = self.viewModel.forecast(for: indexPath.row) {
            cell.configure(with: forecast)
        }

        return cell
    }
}
