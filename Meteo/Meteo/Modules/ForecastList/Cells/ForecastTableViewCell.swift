//
//  ForecastTableViewCell.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.dateLabel.text = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.dateLabel.text = nil
    }

    func configure(with forecast: ForecastDTO) {
        self.dateLabel.text = "\(forecast.date.displayString)"
    }

    func configure(with forecast: Forecast) {
        guard let date = forecast.a_date as Date? else {
            return
        }

        self.dateLabel.text = "\(date.displayString)"
        self.accessoryType = .disclosureIndicator
    }
    
}

extension ForecastTableViewCell: TableViewCellXibProtocol {
    static var xibName: String {
        return "ForecastTableViewCell"
    }
    static var identifier: String {
        return "ForecastTableViewCell"
    }
}
