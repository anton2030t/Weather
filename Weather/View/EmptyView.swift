//
//  EmptyView.swift
//  Weather
//
//  Created by Anton Larchenko on 10.07.2020.
//  Copyright © 2020 Anton Larchenko. All rights reserved.
//

import UIKit

/// Used to show when there's no data
final class EmptyView: UIView {
  private lazy var imageView: UIImageView = self.makeImageView()
  lazy var titleLabel: UILabel = self.makeLabel()
    lazy var subLabel: UILabel = self.makeSubLabel()

    required init(text: String? = "", subText: String? = "") {
    super.init(frame: .zero)

    isUserInteractionEnabled = false
    addSubviews([imageView, titleLabel, subLabel])
    titleLabel.text = text
        subLabel.text = subText
    setupConstraints()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
      imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
      
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      
      subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
      subLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      subLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
    ])
  }

  // MARK: - Make

  private func makeImageView() -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.image = UIImage(named: Constants.Image.name.kSadCloud)?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .lightGray
    return imageView
  }

  private func makeLabel() -> UILabel {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .darkGray
    label.numberOfLines = 0
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    return label
  }
    
    private func makeSubLabel() -> UILabel {
      let label = UILabel()
      label.textAlignment = .center
      label.textColor = .lightGray
      label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
      return label
    }
}
