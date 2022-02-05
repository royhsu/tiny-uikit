//
//  UICollectionViewFlowLayout+Utilities.swift
//  
//
//  Created by Roy Hsu on 2022/2/4.
//

import UIKit

extension UICollectionViewFlowLayout {
  /// Available content rect to place items and supplementaries.
  public var contentRect: CGRect {
    guard let collectionView = collectionView else { return .zero }
    return collectionView.frame.inset(by: sectionInset)
  }
}

// MARK: - Vertically Scrolling Grid Layout

extension UICollectionViewFlowLayout {
  /// The item width that can fit within the given `columnCount`.
  public func itemWidthForVerticallyScrollingGridLayout(columnCount: Int)
  -> CGFloat {
    precondition(columnCount > 0)
    let interitemSpacerCount = columnCount - 1
    let totalSpacingForInteritems = minimumInteritemSpacing
      * CGFloat(interitemSpacerCount)
    let width = (contentRect.width - totalSpacingForInteritems)
      / CGFloat(columnCount)
    // Rounded for pixel-perfect.
    // We must use rounded down value to prevent exceeding `columnCount`.
    return width.rounded(.down)
  }
}
