//
//  UITableViewRow.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public struct UITableViewRow<UIViewType: UIView> {
  private let _reuseIdentifier: () -> String
  private let _makeUITableViewCell: (Context) -> UITableViewCellType
  private let _updateUITableViewCell: (UITableViewCellType, Context) -> Void
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    onSelect: (() -> Void)? = nil
  )
  where Content.UIViewType == UIViewType {
    let _reuseIdentifier = { String(describing: UITableViewCellType.self) }
    self._reuseIdentifier = _reuseIdentifier
    self._makeUITableViewCell = { context in
      context.coordinator.tableView.dequeueReusableCell(
        withIdentifier: _reuseIdentifier(),
        for: context.coordinator.indexPath
      ) as! UITableViewCellType
    }
    self._updateUITableViewCell = { cell, context in
      cell.updateUI(
        with: content,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self.onSelect = onSelect
  }
  
  public func makeUITableViewCell(context: Context) -> UITableViewCellType {
    _makeUITableViewCell(context)
  }

  public func updateUITableViewCell(
    _ cell: UITableViewCellType,
    context: Context
  ) {
    _updateUITableViewCell(cell, context)
  }
}

// MARK: - UITableViewCellRegistration

extension UITableViewRow: UITableViewCellRegistration {
  public var reuseIdentifier: String {
    _reuseIdentifier()
  }
  
  public var cellType: UITableViewCell.Type {
    UITableViewCellType.self
  }
}

// MARK: - Helpers

public extension UITableViewRow {
  typealias UITableViewCellType = UITableViewBridgeCell<UIViewType>
  typealias Context = UIViewRepresentableContext<Coordinator>
  
  struct Coordinator {
    public var tableView: UITableView
    public var indexPath: IndexPath

    public init(tableView: UITableView, indexPath: IndexPath) {
      self.tableView = tableView
      self.indexPath = indexPath
    }
  }
}
