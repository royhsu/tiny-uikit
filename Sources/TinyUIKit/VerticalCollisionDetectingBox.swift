//
//  VerticalCollisionDetectingBox.swift
//  
//
//  Created by Roy Hsu on 2022/4/16.
//

import CoreGraphics

struct VerticalCollisionDetectingBox {
  /// The frame of box.
  let frame: CGRect
  /// The leading point used for detecting collsion.
  let collisionDetectingLeadingPoint: CGFloat
  /// The trailing point used for detecting collsion.
  let collisionDetectingTrailingPoint: CGFloat
  
  init(
    frame: CGRect,
    environmentVelocityDirection: VelocityDirection
  ) {
    self.frame = frame
    switch environmentVelocityDirection {
    case .positive:
      self.collisionDetectingLeadingPoint = frame.maxY
      self.collisionDetectingTrailingPoint = frame.minY
    case .negative:
      self.collisionDetectingLeadingPoint = frame.maxY
      self.collisionDetectingTrailingPoint = frame.minY
    }
  }
}

enum VelocityDirection {
  case positive, negative
}
