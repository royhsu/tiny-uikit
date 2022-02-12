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
    let proposedSize = cell.systemLayoutSizeFitting(
      CGSize(
        width: itemWidth,
        height: UIView.layoutFittingCompressedSize.height
      ),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .fittingSizeLevel
    )
    // WORKAROUND: iOS 12.X will unexpectedly return 0.0 width from
    // `proposedSize` above.
    // We have to use the `itemWidth` explicitly in order to fix this.
    // Reference:
    // - [UICollectionViewFlowLayout estimatedItemSize does not work properly with iOS12 though it works fine with iOS 11.*](https://stackoverflow.com/questions/51718787/uicollectionviewflowlayout-estimateditemsize-does-not-work-properly-with-ios12-t/52389062#52389062)
    // - [In iOS 12, when does the UICollectionView layout cells, use autolayout in nib](https://stackoverflow.com/questions/51375566/in-ios-12-when-does-the-uicollectionview-layout-cells-use-autolayout-in-nib/52428617#52428617)
    // - [iOS 12 Release Notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-12-release-notes)
    return CGSize(width: itemWidth, height: proposedSize.height)
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
