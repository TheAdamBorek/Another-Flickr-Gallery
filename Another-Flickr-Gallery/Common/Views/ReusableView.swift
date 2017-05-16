//
// Created by Adam Borek on 15.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reusableIdentifier: String { get }
}

extension ReusableView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {}
extension UICollectionViewCell: ReusableView {}

extension UITableView {

    func register<Cell: UITableViewCell>(cell: Cell.Type) where Cell: ReusableView, Cell: NibHaving {
        self.register(Cell.nib(), forCellReuseIdentifier: Cell.reusableIdentifier)
    }

    func dequeueCell<Cell: UITableViewCell>(at indexPath: IndexPath) -> Cell where Cell: ReusableView {
        let cellIdentifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            return Cell(style: .default, reuseIdentifier: cellIdentifier)
        }
        return cell
    }
}

extension UICollectionView {

    func register<Cell: UICollectionViewCell>(cell: Cell.Type) where Cell: ReusableView, Cell: NibHaving {
        self.register(Cell.nib(), forCellWithReuseIdentifier: Cell.reusableIdentifier)
    }

    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell where Cell: ReusableView {
        let cellIdentifier = Cell.reusableIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            return Cell()
        }
        return cell
    }
}
