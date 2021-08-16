//
//  UICollectionView+Registrations.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public extension UICollectionView {
  func register<Registration: UICollectionViewCellRegistration>(
    _ registration: Registration
  ) {
    register(
      registration.cellType,
      forCellWithReuseIdentifier: registration.reuseIdentifier
    )
  }
}
