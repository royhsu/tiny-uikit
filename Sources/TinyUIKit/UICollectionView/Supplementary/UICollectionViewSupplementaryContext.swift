//
//  UICollectionViewSupplementaryContext.swift
//  
//
//  Created by Roy Hsu on 2022/2/3.
//

import UIKit

public struct UICollectionViewSupplementaryContext {
  public var viewProvidingTarget: ViewProvidingTarget
  public var elementKind: String
  public var indexPath: IndexPath
  public var collectionView: UICollectionView
  public var collectionViewLayout: UICollectionViewLayout
  public var environment: Environment
}

// MARK: - Helpers

extension UICollectionViewSupplementaryContext {
  public typealias Environment = UIEnvironmentValues
  
  public enum ViewProvidingTarget {
    /// For `collectionView(_:layout:referenceSizeForHeaderInSection:)`, `collectionView(_:layout:referenceSizeForFooterInSection:)`.
    case sizeForSupplementary
    
    /// For `collectionView(_:viewForSupplementaryElementOfKind:at:)`.
    case viewForSupplementary
  }
}
