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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with forecast: ForecastDTO) {
        self.dateLabel.text = "\(forecast.date)"
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
