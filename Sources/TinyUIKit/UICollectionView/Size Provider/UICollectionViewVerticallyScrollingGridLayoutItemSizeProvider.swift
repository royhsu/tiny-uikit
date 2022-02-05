//
//  UICollectionViewVerticallyScrollingGridLayoutItemSizeProvider.swift
//  
//
//  Created by Roy Hsu on 2022/2/4.
//

import UIKit

public struct UICollectionViewVerticallyScrollingGridLayoutItemSizeProvider
: UICollectionViewItemSizeProvider {
  var columnCount: Int
  
  public func collectionView(
    _ collectionView: UICollectionView,
    _ collectionViewLayout: UICollectionViewLayout,
    sizeFor cell: UICollectionViewCell,
    at indexPath: IndexPath
  ) -> CGSize {
    guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
    else {
      fatalError("You Must use UICollectionViewFlowLayout for UICollectionViewVerticallyScrollingGridLayoutItemSizeProvider.")
    }
    let itemWidth = flowLayout.itemWidthForVerticallyScrollingGridLayout(
      columnCount: columnCount
    )
    return cell.systemLayoutSizeFitting(
      CGSize(
        width: itemWidth,
        height: UIView.layoutFittingCompressedSize.height
      ),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
  }
}

// MARK: - UICollectionViewItemSizeProvider

extension UICollectionViewItemSizeProvider
where Self == UICollectionViewVerticallyScrollingGridLayoutItemSizeProvider {
  public static var listLayout: Self {
    verticallyScrollingGridLayout(columnCount: 1)
  }
  
  public static func verticallyScrollingGridLayout(columnCount: Int) -> Self {
    Self(columnCount: columnCount)
  }
}
