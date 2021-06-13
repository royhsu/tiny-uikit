//
//  UICollectionViewCellRegistration.swift
//  
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public protocol UICollectionViewCellRegistration {
  var reuseIdentifier: String { get }
  var cellType: UICollectionViewCell.Type { get }
}
