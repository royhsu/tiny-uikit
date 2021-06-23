//
//  UICollectionViewCellRegistrationManager.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UICollectionViewCellRegistrationManager {
  public let collectionView: UICollectionView

  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }
}

public extension UICollectionViewCellRegistrationManager {
  func registerAll<Registrations: Sequence>(
    _ registrations: Registrations
  ) where Registrations.Element == UICollectionViewCellRegistration {
    for registration in registrations {
      collectionView.register(
        registration.cellType,
        forCellWithReuseIdentifier: registration.reuseIdentifier
      )
    }
  }
}
