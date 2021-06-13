//
//  UIViewRepresentable.swift
//  
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public protocol UIViewRepresentable {
  associatedtype View: UIView
  associatedtype Coordinator = Void
  typealias Context = UIViewRepresentableContext<Coordinator>
  
  /// UICollectionView/UITableView can leverage this reuse identifier when registering/dequeuing cells.
  ///
  /// Default implementation provided.
  /// Default implementation uses the type description of instance itself. Beware of not using
  /// type-erasured `View` if you want to use the default implementation.
  var reuseIdentifier: String { get }
  
  func makeUIView(context: Context) -> View
  
  func updateUIView(_ view: View, context: Context)
  
  /// Default implementation provided when `Coordinator` is Void.
  func makeCoordinator() -> Coordinator
}

extension UIViewRepresentable {
  public var reuseIdentifier: String {
    String(describing: type(of: self))
  }
}

extension UIViewRepresentable where Coordinator == Void {
  public func makeCoordinator() -> Coordinator { () }
}

// MARK: - AnyUIViewRepresentable

public struct AnyUIViewRepresentable<View: UIView, Coordinator>
: UIViewRepresentable {
  public typealias Context = UIViewRepresentableContext<Coordinator>

  private let _reuseIdentifier: () -> String
  private let _makeView: (Context) -> UIView
  private let _updateView: (UIView, Context) -> Void
  private let _makeCoordinator: () -> Coordinator

  public init<Value: UIViewRepresentable>(_ value: Value)
  where Value.View == View, Value.Coordinator == Coordinator {
    self._reuseIdentifier = { value.reuseIdentifier }
    self._makeView = { context in
      value.makeUIView(
        context: .init(
          coordinator: context.coordinator,
          environment: context.environment
        )
      )
    }
    self._updateView = { view, context in
      value.updateUIView(
        view as! Value.View,
        context: .init(
          coordinator: context.coordinator,
          environment: context.environment
        )
      )
    }
    self._makeCoordinator = value.makeCoordinator
  }

  public var reuseIdentifier: String { _reuseIdentifier() }
  
  public func makeUIView(context: Context) -> UIView {
    _makeView(context)
  }

  public func updateUIView(_ view: UIView, context: Context) {
    _updateView(view, context)
  }
  
  public func makeCoordinator() -> Coordinator {
    _makeCoordinator()
  }
}
