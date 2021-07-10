//
//  UITableViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/6/22.
//

import TinyUIKit
import UIKit

public struct UITableViewSupplementary<UIViewType: UIView> {
  public let reuseIdentifier: String
  private let _makeUITableViewSupplementaryView
    : (Context) -> UIViewType
  private let _updateUITableViewSupplementaryView
    : (UITableViewSupplementaryViewType, Context) -> Void
  
  public init<Value: UIViewRepresentable>(
    reuseIdentifier: String,
    value: Value
  )
  where Value.UIViewType == UIViewType {
    self.reuseIdentifier = reuseIdentifier
    self._makeUITableViewSupplementaryView = { context in
      value.makeUIView(
        context: Value.Context(
          coordinator: value.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self._updateUITableViewSupplementaryView = { view, context in
      view.updateUI(
        with: value,
        context: Value.Context(
          coordinator: value.makeCoordinator(),
          environment: context.environment
        )
      )
    }
  }

  public func makeUITableViewSupplementaryView(context: Context)
  -> UITableViewSupplementaryViewType {
    UITableViewSupplementaryViewType()
  }
  
  public func updateUITableViewSupplementaryView(
    _ view: UITableViewSupplementaryViewType,
    context: Context
  ) {
    _updateUITableViewSupplementaryView(view, context)
  }
}

// MARK: - Helpers

extension UITableViewSupplementary {
  public typealias UITableViewSupplementaryViewType
    = UITableViewSupplementaryBridgeView<UIViewType>
  public typealias Context = UIViewRepresentableContext<Coordinator>
  
  public struct Coordinator {
    public var tableView: UITableView
    
    public init(tableView: UITableView) {
      self.tableView = tableView
    }
  }
}
