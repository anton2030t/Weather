//
//  AdapterCollection.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

/// A generic adapter to act as convenient DataSource and Delegate for UICollectionView
final class AdapterCollection<T, Cell: UICollectionViewCell>: NSObject,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  var items: [T] = []
  var configure: ((T, Cell) -> Void)?
  var select: ((T) -> Void)?
  var cellHeight: CGFloat = 40

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = items[indexPath.item]

    let cell: Cell = collectionView.dequeue(indexPath: indexPath)
    configure?(item, cell)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = items[indexPath.row]
    select?(item)
  }

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.size.width, height: cellHeight)
  }
}

