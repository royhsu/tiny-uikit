//
//  UICollectionViewLayoutSize.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import CoreGraphics

public struct UICollectionViewLayoutSize {
  public var width: CGFloat
  /// Default is `.absolute`.
  public var widthDimension: UICollectionViewLayoutDimension
  public var height: CGFloat
  /// Default is `.absolute`.
  public var heightDimension: UICollectionViewLayoutDimension
  
  public init(
    width: CGFloat,
    widthDimension: UICollectionViewLayoutDimension? = nil,
    height: CGFloat,
    heightDimension: UICollectionViewLayoutDimension? = nil
  ) {
    self.width = width
    self.widthDimension = widthDimension ?? .absolute
    if widthDimension?.isFractional == true {
      assert(width <= 1.0)
    }
    self.height = height
    self.heightDimension = heightDimension ?? .absolute
    if heightDimension?.isFractional == true {
      assert(height <= 1.0)
    }
  }
}
