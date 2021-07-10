//
//  UITableViewRow.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public struct UITableViewRow {
  private let _reuseIdentifier: () -> String
  private let _cellType: () -> UITableViewCell.Type
  private let _makeUITableViewCell: (Context) -> UITableViewCell
  private let _updateUITableViewCell: (UITableViewCell, Context) -> Void
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    onSelect: (() -> Void)? = nil
  ) {
    typealias Cell = UITableViewBridgeCell<Content.UIViewType>
    
    let _reuseIdentifier = { String(describing: Cell.self) }
    self._reuseIdentifier = _reuseIdentifier
    self._cellType = { Cell.self }
    self._makeUITableViewCell = { context in
      let tableView = context.coordinator.tableView
      let reuseIdentifier = _reuseIdentifier()
      tableView.register(Cell.self, forCellReuseIdentifier: reuseIdentifier)
      return tableView.dequeueReusableCell(
        withIdentifier: reuseIdentifier,
        for: context.coordinator.indexPath
      ) as! Cell
    }
    self._updateUITableViewCell = { cell, context in
      let cell = cell as! Cell
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
  
  public func makeUITableViewCell(context: Context) -> UITableViewCell {
    _makeUITableViewCell(context)
  }

  public func updateUITableViewCell(
    _ cell: UITableViewCell,
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
    _cellType()
  }
}

// MARK: - Helpers

public extension UITableViewRow {
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
