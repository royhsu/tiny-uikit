//
//  UICollectionViewSupplementaryContext.swift
//  
//
//  Created by Roy Hsu on 2022/2/3.
//

import UIKit

public struct UICollectionViewSupplementaryContext {
  public var viewProvidingStrategy: ViewProvidingStrategy
  public var elementKind: String
  public var indexPath: IndexPath
  public var collectionView: UICollectionView
  public var collectionViewLayout: UICollectionViewLayout
  public var environment: Environment
}

// MARK: - Helpers

extension UICollectionViewSupplementaryContext {
  public typealias Environment = UIEnvironmentValues
  
  public enum ViewProvidingStrategy {
    /// Useful as a template view when calculating its intrinsic content size.
    case new
    /// Dequeued by UICollectionView.
    case reused
  }
}
