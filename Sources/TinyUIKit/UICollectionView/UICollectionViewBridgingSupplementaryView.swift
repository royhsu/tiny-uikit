//
//  UICollectionViewBridgingSupplementaryView.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import UIKit

public final class UICollectionViewBridgingSupplementaryView
<UIViewType: UIView>: UICollectionReusableView {
  private(set) weak var bridgingView: UIViewType?
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    
    let reusableView = bridgingView as? Reusable
    reusableView?.prepareForReuse()
  }
}

// MARK: - Helpers

extension UICollectionViewBridgingSupplementaryView {
  public func installBridgingView(_ view: UIViewType) {
    // Uninstall old bridging view before installing new one.
    bridgingView?.removeFromSuperview()
    
    // Keep the weak reference to the new bridging view.
    bridgingView = view
    
    // Handle layout.
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    
    NSLayoutConstraint.activate([
      // Horizontal axis.
      view.leadingAnchor.constraint(equalTo: leadingAnchor),
      view.trailingAnchor.constraint(equalTo: trailingAnchor),
        
      // Vertical axis.
      view.topAnchor.constraint(equalTo: topAnchor),
      view.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
