//
//  UICollectionViewBridgeCell.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public final class UICollectionViewBridgeCell<Value: UIViewRepresentable>
: UICollectionViewCell {
  private(set) var bridgeView: Value.UIViewType?

  override public func prepareForReuse() {
    super.prepareForReuse()
    let reusableView = bridgeView as? Reusable
    reusableView?.prepareForReuse()
  }
}

public extension UICollectionViewBridgeCell {
  func updateUI(with value: Value, context: Value.Context) {
    if let bridgeView = bridgeView , bridgeView.superview === contentView {
      value.updateUIView(bridgeView, context: context)
    } else {
      let newView = value.makeUIView(context: context)
      value.updateUIView(newView, context: context)
      bridgeView = newView

      // Layout.
      newView.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(newView)
      NSLayoutConstraint.activate([
        // Horizontal.
        newView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        newView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

        // Vertical.
        newView.topAnchor.constraint(equalTo: contentView.topAnchor),
        newView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ])
    }
  }
}
