//
//  UIEnvironmentValues.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public struct UIEnvironmentValues {
  public var traitCollection: UITraitCollection?

  public init(traitCollection: UITraitCollection? = nil) {
    self.traitCollection = traitCollection
  }
}

// MARK: - UIViewController

extension UIViewController {
  public var environment: UIEnvironmentValues {
    UIEnvironmentValues(traitCollection: traitCollection)
  }
}
