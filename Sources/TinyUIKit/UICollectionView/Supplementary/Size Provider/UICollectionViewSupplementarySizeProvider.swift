//
//  UICollectionViewSupplementarySizeProvider.swift
//  
//
//  Created by Roy Hsu on 2022/2/6.
//

import UIKit

public protocol UICollectionViewSupplementarySizeProvider {
  func collectionView(
    _ collectionView: UICollectionView,
    _ collectionViewLayout: UICollectionViewLayout,
    elementKind: String,
    sizeFor view: UICollectionReusableView,
    at indexPath: IndexPath
  ) -> CGSize
}
