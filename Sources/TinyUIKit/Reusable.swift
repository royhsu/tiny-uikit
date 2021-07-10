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
  func prepareForReuse()
}
