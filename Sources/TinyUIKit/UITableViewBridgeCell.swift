//
//  UITableViewBridgeCell.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public final class UITableViewBridgeCell<Value: UIViewRepresentable>:
  UITableViewCell
{
  private(set) var bridgeView: Value.View?

  override public func prepareForReuse() {
    super.prepareForReuse()
    bridgeView?.prepareForReuse()
  }
}

public extension UITableViewBridgeCell {
  func updateUI(with value: Value, context: Value.Context) {
    if let bridgeView = bridgeView {
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
