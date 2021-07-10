//
//  UIViewRepresentableContext.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

public struct UIViewRepresentableContext<Coordinator> {
  public var coordinator: Coordinator
  public var environment: Environment

  public init(
    coordinator: Coordinator,
    environment: Environment = Environment()
  ) {
    self.coordinator = coordinator
    self.environment = environment
  }
}

// MARK: - Helpers

public extension UIViewRepresentableContext {
  typealias Environment = UIEnvironmentValues
}
