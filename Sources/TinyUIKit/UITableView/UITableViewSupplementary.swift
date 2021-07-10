//
//  UITableViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/6/22.
//

import UIKit

public struct UITableViewSupplementary {
  private let _reuseIdentifier: () -> String
  private let _supplementaryViewType: () -> UITableViewSupplementaryView.Type
  private let _makeUITableViewSupplementaryView
    : (Context) -> UITableViewSupplementaryView
  private let _updateUITableViewSupplementaryView
    : (UITableViewSupplementaryView, Context) -> Void
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    onSelect: (() -> Void)? = nil
  ) {
    typealias SupplementaryView
      = UITableViewSupplementaryBridgeView<Content.UIViewType>
    
    let _reuseIdentifier = { String(describing: SupplementaryView.self) }
    self._reuseIdentifier = _reuseIdentifier
    self._supplementaryViewType = { SupplementaryView.self }
    self._makeUITableViewSupplementaryView = { context in
      let tableView = context.coordinator.tableView
      let reuseIdentifier = _reuseIdentifier()
      tableView.register(
        SupplementaryView.self,
        forCellReuseIdentifier: reuseIdentifier
      )
      return tableView
        .dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
        as! SupplementaryView
    }
    self._updateUITableViewSupplementaryView = { view, context in
      let view = view as! SupplementaryView
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
  -> UITableViewSupplementaryView {
    _makeUITableViewSupplementaryView(context)
  }
  
  public func updateUITableViewSupplementaryView(
    _ view: UITableViewSupplementaryView,
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
  
  public var supplementaryType: UITableViewSupplementaryView.Type {
    _supplementaryViewType()
  }
}

// MARK: - Helpers

extension UITableViewSupplementary {
  public typealias Context = UIViewRepresentableContext<Coordinator>
  
  public struct Coordinator {
    public var tableView: UITableView
    
    public init(tableView: UITableView) {
      self.tableView = tableView
    }
  }
}

public typealias UITableViewSupplementaryView = UITableViewHeaderFooterView
