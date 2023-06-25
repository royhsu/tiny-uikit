//
//  UICollectionViewAutomaticSupplementarySizeProvider.swift
//  
//
//  Created by Roy Hsu on 2022/2/6.
//


import UIKit

public struct UICollectionViewAutomaticSupplementarySizeProvider
: UICollectionViewSupplementarySizeProvider {
  var targetSize: CGSize
  
  public func collectionView(
    _ collectionView: UICollectionView,
    _ collectionViewLayout: UICollectionViewLayout,
    elementKind: String,
    sizeFor view: UIView,
    at indexPath: IndexPath
  ) -> CGSize {
    view.systemLayoutSizeFitting(targetSize)
  }
}

// MARK: - UICollectionViewItemSizeProvider

extension UICollectionViewSupplementarySizeProvider
where Self == UICollectionViewAutomaticSupplementarySizeProvider {
  public static var fittingCompressedSize: Self {
    Self(targetSize: UIView.layoutFittingCompressedSize)
  }
  
  public static var fittingExpandedSize: Self {
    Self(targetSize: UIView.layoutFittingExpandedSize)
  }
}
