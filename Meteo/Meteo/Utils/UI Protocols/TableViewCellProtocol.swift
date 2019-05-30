//
//  TableViewCellProtocol.swift
//  Meteo
//
//  Created by Kévin Mondésir on 30/05/2019.
//  Copyright © 2019 Kévin Mondésir. All rights reserved.
//

import Foundation
import UIKit

protocol TableViewCellProtocol {
    static func cellRegistration(on tableView: UITableView)
    static func dequeueCell(from tableView: UITableView, forIndexPath indexPath: IndexPath) -> Self
}

protocol TableViewCellProtocolInit {
    func commonInit()
}

protocol CollectionViewCellProtocol {
    static func cellRegistration(on collectionView: UICollectionView)
    static func dequeueCell(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> Self
}

protocol TableViewCellXibProtocol {
    associatedtype TableViewCell: UITableViewCell = Self


    static var xibName: String {get}
    static var identifier: String {get}

    static func dequeueCell(from tableView: UITableView) -> Self
}

extension TableViewCellXibProtocol {
    static func cellRegistration(on tableView: UITableView) {
        tableView.register(UINib(nibName: self.xibName, bundle: nil), forCellReuseIdentifier: self.identifier)
    }

    private static func subDequeueCell(with tableView: UITableView, forIndexPath indexPath: IndexPath) -> Self? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier, for: indexPath) as? Self else {
            return nil
        }

        if let cell = cell as? TableViewCellProtocolInit {
            cell.commonInit()
        }

        return cell
    }

    private static func subDequeueCell(with tableView: UITableView) -> Self? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.identifier) as? Self else {
            return nil
        }

        if let cell = cell as? TableViewCellProtocolInit {
            cell.commonInit()
        }

        return cell
    }

    static func dequeueCell(from tableView: UITableView, for indexPath: IndexPath) -> Self {
        guard let _ = subDequeueCell(with: tableView) else {
            self.cellRegistration(on: tableView)
            return self.subDequeueCell(with: tableView, forIndexPath: indexPath)!
        }
        return subDequeueCell(with: tableView, forIndexPath: indexPath)!
    }

    static func dequeueCell(from tableView: UITableView) -> Self {
        guard let cell = subDequeueCell(with: tableView) else {
            self.cellRegistration(on: tableView)
            return self.subDequeueCell(with: tableView)!
        }
        return cell
    }
}
