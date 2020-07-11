//
//  UIView+Ext.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

extension UIView {

  /// Convenient method to add a list of subviews
  func addSubviews(_ views: [UIView]) {
    views.forEach({
      addSubview($0)
    })
  }

  /// Apply mask to round corners
  func round(corners: UIRectCorner) {
    let raddi = bounds.size.height / 2
    let path = UIBezierPath(
      roundedRect: bounds,
      byRoundingCorners: corners,
      cornerRadii: CGSize(width: raddi, height: raddi)
    )

    let maskLayer = CAShapeLayer()

    maskLayer.path = path.cgPath
    layer.mask = maskLayer
  }
}

extension UIView {
  @discardableResult func addSubview<S: UIView>(_ subview: S, constraints: [NSLayoutConstraint]) -> S {
    subview.translatesAutoresizingMaskIntoConstraints = false
    addSubview(subview)
    NSLayoutConstraint.activate(constraints)
    return subview
  }
}

extension UIView {
    func animate(from: CGFloat, to: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            
            self.transform = CGAffineTransform.init(scaleX: from, y: from)
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform.init(scaleX: to, y: to)
            })
        })
    }
}

extension UIView {

    func displayToast(_ message : String) {

        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let window = delegate.window else {
            return
        }
        if let toast = window.subviews.first(where: { $0 is UILabel && $0.tag == -1001 }) {
            toast.removeFromSuperview()
        }

        let toastView = UILabel()
        toastView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastView.textColor = UIColor.white
        toastView.textAlignment = .center
        toastView.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        toastView.layer.cornerRadius = 10
        toastView.layer.masksToBounds = true
        toastView.text = message
        toastView.numberOfLines = 0
        toastView.alpha = 0
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.tag = -1001

        window.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -60),
            toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 15),
            toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -15),
            toastView.heightAnchor.constraint(equalToConstant: 60)
        ])

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastView.alpha = 1
        }, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                toastView.alpha = 0
            }, completion: { finished in
                toastView.removeFromSuperview()
            })
        })
    }
}


