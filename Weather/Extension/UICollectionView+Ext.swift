//
//  UICollectionView+Ext.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

extension UICollectionView {

  /// Generic function to dequeue cell
  func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell {
    // swiftlint:disable force_cast
    return dequeueReusableCell(withReuseIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
  }

  /// Generic function to register cell
  func register(cellType: UICollectionViewCell.Type) {
    register(cellType, forCellWithReuseIdentifier: String(describing: cellType.self))
  }
}
