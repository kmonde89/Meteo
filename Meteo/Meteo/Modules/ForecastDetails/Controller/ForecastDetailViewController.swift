//
//  ForecastDetailViewController.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import UIKit

class ForecastDetailViewController: UIViewController {
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!

    var forecastDetailViewModel: ForecastDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.bind()
    }

    func bind() {
        guard let forecastDetailViewModel = self.forecastDetailViewModel else {
            return
        }

        self.navigationItem.title = forecastDetailViewModel.date?.displayString

        self.temperatureLabel.text = forecastDetailViewModel.temperature
        self.humidityLabel.text = forecastDetailViewModel.humidity
        self.cloudinessLabel.text = forecastDetailViewModel.cloudiness
        self.windSpeedLabel.text = forecastDetailViewModel.windSpeed
        self.windDirectionLabel.text = forecastDetailViewModel.windDirection
    }

}

extension ForecastDetailViewController: StoryboardControllerProtocol {
    static var storyboardName: String {
        return "ForecastDetail"
    }

    static var identifier: String {
        return "ForecastDetailViewController"
    }
}
