//
//  UITableViewSupplementaryBridgeView.swift
//  
//
//  Created by Roy Hsu on 2021/6/22.
//

import TinyUIKit
import UIKit

public final class UITableViewSupplementaryBridgeView
<UIViewType: UIView>: UIView {
  private(set) var bridgeView: UIViewType?
  
  public func prepareForReuse() {
    let reusableView = bridgeView as? Reusable
    reusableView?.prepareForReuse()
  }
}

extension UITableViewSupplementaryBridgeView {
  func updateUI<Value: UIViewRepresentable>(
    with value: Value,
    context: Value.Context
  ) where Value.UIViewType == UIViewType {
    if let bridgeView = bridgeView, bridgeView.superview === self {
      value.updateUIView(bridgeView, context: context)
    } else {
      let newView = value.makeUIView(context: context)
      value.updateUIView(newView, context: context)
      bridgeView = newView
      
      // Layout.
      newView.translatesAutoresizingMaskIntoConstraints = false
      addSubview(newView)
      NSLayoutConstraint.activate([
        // Horizontal.
        newView.leadingAnchor.constraint(equalTo: leadingAnchor),
        newView.trailingAnchor.constraint(equalTo: trailingAnchor),
        
        // Vertical.
        newView.topAnchor.constraint(equalTo: topAnchor),
        newView.bottomAnchor.constraint(equalTo: bottomAnchor),
      ])
    }
  }
}
