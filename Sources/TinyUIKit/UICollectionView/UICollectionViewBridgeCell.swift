//
//  UICollectionViewBridgeCell.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public final class UICollectionViewBridgeCell<UIViewType: UIView>
: UICollectionViewCell {
  private(set) weak var bridgeView: UIViewType?
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    let reusableView = bridgeView as? Reusable
    reusableView?.prepareForReuse()
  }
}

// MARK: - Helpers

extension UICollectionViewBridgeCell {
  public func updateUI<Value: UIViewRepresentable>(
    with value: Value,
    context: Value.Context
  ) where Value.UIViewType == UIViewType {
    if let bridgeView = bridgeView,
       bridgeView.superview === contentView {
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
