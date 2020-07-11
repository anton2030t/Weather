//
//  UIViewController+Ext.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
  
  func presentSafariViewController(for url: URL) {
    let safariController = SFSafariViewController(url: url)
    if #available(iOS 10.0, *) {
        safariController.preferredControlTintColor = Constants.Theme.Color.ContentElement.title
    } else {
        // Fallback on earlier versions
    }
    if #available(iOS 13, *) {
      safariController.modalPresentationStyle = .automatic
    } else {
      safariController.modalPresentationStyle = .overFullScreen
    }
    present(safariController, animated: true, completion: nil)
  }
}

import UIKit

extension UIViewController {
  /// Add child view controller and its view
  func add(childViewController: UIViewController) {
    addChild(childViewController)
    view.addSubview(childViewController.view)
    childViewController.didMove(toParent: self)
  }
}
