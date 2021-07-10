//
//  UITableViewRow.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public struct UITableViewRow<UIViewType: UIView> {
  public let reuseIdentifier: String
  private let _makeUITableViewCell: (Context) -> UITableViewCellType
  private let _updateUITableViewCell: (UITableViewCellType, Context) -> Void
  
  public init<Value: UIViewRepresentable>(
    reuseIdentifier: String,
    value: Value
  )
  where Value.UIViewType == UIViewType {
    self.reuseIdentifier = reuseIdentifier
    self._makeUITableViewCell = { context in
      context.coordinator.tableView.dequeueReusableCell(
        withIdentifier: reuseIdentifier,
        for: context.coordinator.indexPath
      ) as! UITableViewCellType
    }
    self._updateUITableViewCell = { cell, context in
      cell.updateUI(
        with: value,
        context: Value.Context(
          coordinator: value.makeCoordinator(),
          environment: context.environment
        )
      )
    }
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
  public var cellType: UITableViewCell.Type {
    UITableViewCellType.self
  }
}

// MARK: - Helpers

public extension UITableViewRow {
  typealias UITableViewCellType = UITableViewBridgeCell<UIViewType>
  typealias Coordinator = UITableViewCellCoordinator
  typealias Context = UIViewRepresentableContext<Coordinator>
}
