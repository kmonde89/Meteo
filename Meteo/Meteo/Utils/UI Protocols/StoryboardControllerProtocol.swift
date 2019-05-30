//
//  StoryboardControllerProtocol.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardControllerProtocol {
    associatedtype ViewController: UIViewController = Self

    static var storyboardName: String {get}
    static var identifier: String {get}
}

extension StoryboardControllerProtocol  {
    static func instantiate() -> ViewController {
        let controller = UIStoryboard(name: Self.storyboardName, bundle: nil).instantiateViewController(withIdentifier: Self.identifier) as! ViewController
        return controller
    }
}
