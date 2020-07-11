//
//  NSLayoutConstraint.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  /// Activate constraints
  ///
  /// - Parameter constraints: An array of constraints
  static func activate(_ constraints: [NSLayoutConstraint]) {
    constraints.forEach {
      ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
      $0.isActive = true
    }
  }

  static func pin(view: UIView, toEdgesOf anotherView: UIView) {
    activate([
      view.topAnchor.constraint(equalTo: anotherView.topAnchor),
      view.leftAnchor.constraint(equalTo: anotherView.leftAnchor),
      view.rightAnchor.constraint(equalTo: anotherView.rightAnchor),
      view.bottomAnchor.constraint(equalTo: anotherView.bottomAnchor)
    ])
  }
}
