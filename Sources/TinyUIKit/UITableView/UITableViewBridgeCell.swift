//
//  UITableViewBridgeCell.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public final class UITableViewBridgeCell<UIViewType: UIView>: UITableViewCell {
  private(set) weak var bridgeView: UIViewType?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUp()
  }
    
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setUp()
  }
  
  private func setUp() {
    // Starting in iOS 14.0, some system cell configurations will contain
    // unexpected background color.
    // We need to explicitly remove it to keep cell background with clear color.
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    if #available(iOS 14.0, *) {
      var configuration = UIBackgroundConfiguration.listPlainCell()
      configuration.backgroundColor = .clear
      backgroundConfiguration = configuration
    }
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    let reusableView = bridgeView as? Reusable
    reusableView?.prepareForReuse()
  }
}

// MARK: - Helpers

extension UITableViewBridgeCell {
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
