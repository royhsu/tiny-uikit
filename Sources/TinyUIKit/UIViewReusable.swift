//
//  UIViewReusable.swift
//  
//
//  Created by Roy Hsu on 2021/6/17.
//

import UIKit

//public protocol UIViewReusable: UIView {
//  /// Default implementation provided.
//  /// Default implementation do nothing.
//  func prepareForReuse()
//}
//
//extension UIViewReusable {
//  public func prepareForReuse() {}
//}

// MARK: - UIReusableView

/// Convenient concrete view that conforms to UIViewReusable.
open class UIReusableView: UIView {
  open func prepareForReuse() {}
}
