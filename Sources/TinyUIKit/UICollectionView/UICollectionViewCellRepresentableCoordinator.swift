//
//  UICollectionViewCellRepresentableCoordinator.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UICollectionViewCellRepresentableCoordinator {
  public var collectionView: UICollectionView
  public var indexPath: IndexPath

  public init(collectionView: UICollectionView, indexPath: IndexPath) {
    self.collectionView = collectionView
    self.indexPath = indexPath
  }
}
