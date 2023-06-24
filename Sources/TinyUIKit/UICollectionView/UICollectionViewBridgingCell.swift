//
//  UICollectionViewBridgingCell.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public final class UICollectionViewBridgingCell<UIViewType: UIView>
: UICollectionViewCell {
  private(set) weak var bridgingView: UIViewType?
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    let reusableView = bridgingView as? Reusable
    reusableView?.prepareForReuse()
  }
}

// MARK: - Helpers

extension UICollectionViewBridgingCell {
  public func installBridgingView(_ view: UIViewType) {
    // Uninstall old bridging view before installing new one.
    bridgingView?.removeFromSuperview()
    
    // Keep the weak reference to the new bridging view.
    bridgingView = view
    
    // Handle layout.
    view.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(view)
    
    // Install active constraints.
    NSLayoutConstraint.activate([
      // Horizontal.
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      // Vertical.
      view.topAnchor.constraint(equalTo: contentView.topAnchor),
      view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }
}
