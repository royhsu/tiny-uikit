//
//  UICollectionViewLayoutDimension.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

public enum UICollectionViewLayoutDimension {
  case absolute, estimated, fractionalWidth, fractionalHeight
}

// MARK: - Helpers

extension UICollectionViewLayoutDimension {
  var isFractional: Bool {
    switch self {
    case .absolute, .estimated:
      return false
    case .fractionalWidth, .fractionalHeight:
      return true
    }
  }
}
