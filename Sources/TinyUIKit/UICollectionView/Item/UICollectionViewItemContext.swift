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
    /// For `collectionView(_:layout:sizeForItemAt:)`.
    case sizeForItem
    
    /// For `collectionView(_:cellForItemAt:)`.
    case cellForItem
  }
}
