//
//  VerticalCollisionDetector.swift
//  
//
//  Created by Roy Hsu on 2022/4/16.
//

import CoreGraphics

struct VerticalCollisionDetector {
  /// The point of where collision happens.
  var collisionPoint: CGFloat
  
  func detectCollision(for box: Box) -> CollisionResult {
    let distanceToLeadingPoint = collisionPoint
      - box.collisionDetectingLeadingPoint
    let distanceToTrailingPoint = collisionPoint
      - box.collisionDetectingTrailingPoint
    
    if distanceToLeadingPoint > 0.0 {
      return CollisionResult(condition: .beforeColliding)
    } else if distanceToTrailingPoint < 0.0 {
      return CollisionResult(condition: .afterColliding)
    } else {
      return CollisionResult(condition: .colliding)
    }
  }
  
  typealias Box = VerticalCollisionDetectingBox
}

struct CollisionResult {
  var condition: CollisionCondition
}

enum CollisionCondition {
  case beforeColliding
  case colliding
  case afterColliding
}
