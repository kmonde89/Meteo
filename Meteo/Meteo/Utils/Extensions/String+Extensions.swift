//
//  String+Extensions.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation

extension String {
    var localizedString: String {
        get {
            return NSLocalizedString(self, comment: self)
        }
    }
}
