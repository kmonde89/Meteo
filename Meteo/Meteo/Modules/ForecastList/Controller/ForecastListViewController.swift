//
//  ForecastListViewController.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import UIKit

class ForecastListViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    var forecastsObserver: KVObserver<[ForecastDTO]>?

    let viewModel = ForecastListViewModel(localisation: "48.85341,2.3488")

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

        let observer = KVObserver<[ForecastDTO]>(viewModel.forecasts)

        observer.closure = { [weak self ] _ in
            self?.tableView.reloadData()
        }
        self.forecastsObserver = observer

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
