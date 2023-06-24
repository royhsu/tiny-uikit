//
//  UICollectionViewAutomaticItemSizeProvider.swift
//  
//
//  Created by Roy Hsu on 2022/2/4.
//

import UIKit

public struct UICollectionViewAutomaticItemSizeProvider
: UICollectionViewItemSizeProvider {
  var targetSize: CGSize
  
  public func collectionView(
    _ collectionView: UICollectionView,
    _ collectionViewLayout: UICollectionViewLayout,
    sizeFor view: UIView,
    at indexPath: IndexPath
  ) -> CGSize {
    view.systemLayoutSizeFitting(targetSize)
  }
}

// MARK: - UICollectionViewItemSizeProvider

extension UICollectionViewItemSizeProvider
where Self == UICollectionViewAutomaticItemSizeProvider {
  public static var fittingCompressedSize: Self {
    Self(targetSize: UIView.layoutFittingCompressedSize)
  }
  
  public static var fittingExpandedSize: Self {
    Self(targetSize: UIView.layoutFittingExpandedSize)
  }
}
