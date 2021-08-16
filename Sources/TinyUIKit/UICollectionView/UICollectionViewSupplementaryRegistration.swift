//
//  UICollectionViewSupplementaryRegistration.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import UIKit

public protocol UICollectionViewSupplementaryRegistration {
  var reuseIdentifier: String { get }
  
  var supplementaryType: UICollectionViewSupplementaryView.Type { get }
}
