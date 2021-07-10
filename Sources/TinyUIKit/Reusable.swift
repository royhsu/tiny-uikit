//
//  UIViewReusable.swift
//
//
//  Created by Roy Hsu on 2021/6/17.
//

import UIKit

/// This is a abstract class.
@available(*, deprecated)
open class UIReusableView: UIView {
  open func prepareForReuse() {}
}

public protocol Reusable {
  /// UICollectionView/UITableView can leverage the reuse identifier when registering/dequeuing cells.
  ///
  /// Default implementation provided.
  /// The default implementation uses the type of instance itself.
  /// Note: you MUST be aware of not using a type-erasured `UIView` existential if you want to use the
  /// default implementation.
  var reuseIdentifier: String { get }
  
  func prepareForReuse()
}

public extension Reusable {
  var reuseIdentifier: String { String(describing: type(of: self)) }
}
