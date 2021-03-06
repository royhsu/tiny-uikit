//
//  UIViewRepresentable.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public protocol UIViewRepresentable {
  associatedtype UIViewType: UIView
  associatedtype Coordinator = Void
  typealias Context = UIViewRepresentableContext<Coordinator>

  func makeUIView(context: Context) -> UIViewType

  func updateUIView(_ view: UIViewType, context: Context)

  /// Default implementation provided when `Coordinator` is Void.
  func makeCoordinator() -> Coordinator
}

// MARK: - Helpers

public extension UIViewRepresentable where Coordinator == Void {
  func makeCoordinator() -> Coordinator { () }
}

// MARK: - AnyUIViewRepresentable

public struct AnyUIViewRepresentable<UIViewType: UIView, Coordinator> {
  public typealias Context = UIViewRepresentableContext<Coordinator>
  
  private let _makeUIView: (Context) -> UIViewType
  private let _updateUIView: (UIViewType, Context) -> Void
  private let _makeCoordinator: () -> Coordinator

  public init<Value: UIViewRepresentable>(_ value: Value)
  where Value.UIViewType == UIViewType, Value.Coordinator == Coordinator
  {
    self._makeUIView = value.makeUIView
    self._updateUIView = value.updateUIView
    self._makeCoordinator = value.makeCoordinator
  }

  public func makeUIView(context: Context) -> UIViewType {
    _makeUIView(context)
  }

  public func updateUIView(_ view: UIViewType, context: Context) {
    _updateUIView(view, context)
  }

  public func makeCoordinator() -> Coordinator {
    _makeCoordinator()
  }
}
