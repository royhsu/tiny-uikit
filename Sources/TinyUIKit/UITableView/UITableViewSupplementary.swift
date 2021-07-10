//
//  UITableViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/6/22.
//

import UIKit

public struct UITableViewSupplementary<UIViewType: UIView> {
  private let _reuseIdentifier: () -> String
  private let _makeUITableViewSupplementaryView
    : (Context) -> UITableViewSupplementaryViewType
  private let _updateUITableViewSupplementaryView
    : (UITableViewSupplementaryViewType, Context) -> Void
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    onSelect: (() -> Void)? = nil
  )
  where Content.UIViewType == UIViewType {
    let _reuseIdentifier = {
      String(describing: UITableViewSupplementaryViewType.self)
    }
    self._reuseIdentifier = _reuseIdentifier
    self._makeUITableViewSupplementaryView = { context in
      context.coordinator.tableView
        .dequeueReusableHeaderFooterView(withIdentifier: _reuseIdentifier())
        as! UITableViewSupplementaryViewType
    }
    self._updateUITableViewSupplementaryView = { view, context in
      view.updateUI(
        with: content,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self.onSelect = onSelect
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

// MARK: - UITableViewSupplementaryRegistration

extension UITableViewSupplementary: UITableViewSupplementaryRegistration {
  public var reuseIdentifier: String {
    _reuseIdentifier()
  }
  
  public var supplementaryType: UITableViewHeaderFooterView.Type {
    UITableViewSupplementaryViewType.self
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
