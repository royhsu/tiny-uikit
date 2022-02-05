//
//  UICollectionViewItemSizeProvider.swift
//  
//
//  Created by Roy Hsu on 2022/2/4.
//

import UIKit

public protocol UICollectionViewItemSizeProvider {
  func collectionView(
    _ collectionView: UICollectionView,
    _ collectionViewLayout: UICollectionViewLayout,
    sizeFor cell: UICollectionViewCell,
    at indexPath: IndexPath
  ) -> CGSize
}
