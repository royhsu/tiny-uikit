//
//  UICollectionViewItemContext.swift
//  
//
//  Created by Roy Hsu on 2022/2/2.
//

import UIKit

public struct UICollectionViewItemContext {
  public var cellProvidingTarget: CellProvidingTarget
  public var indexPath: IndexPath
  public var collectionView: UICollectionView
  public var collectionViewLayout: UICollectionViewLayout
  public var environment: Environment
}

// MARK: - Helpers

extension UICollectionViewItemContext {
  public typealias Environment = UIEnvironmentValues
  
  public enum CellProvidingTarget {
    /// Equivalent to `collectionView(_:layout:sizeForItemAt:)`.
    case sizeForItem
    
    /// Equivalent to `collectionView(_:cellForItemAt:)`.
    case cellForItem
  }
}
