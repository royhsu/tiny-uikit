//
//  UITableViewRow.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public struct UITableViewRow<Value: UIViewRepresentable>:
  UITableViewCellRepresentable
{
  public var value: Value
  /// We don't want the default implementation since `Value` may have already been type-erased from
  /// caller.
  public var reuseIdentifier: String { value.reuseIdentifier }

  public init(value: Value) {
    self.value = value
  }

  public func updateUICell(_ cell: Cell, context: Context) {
    cell.updateUI(
      with: value,
      context: .init(
        coordinator: value.makeCoordinator(),
        environment: context.environment
      )
    )
  }
}

// MARK: - Cell

public extension UITableViewRow {
  typealias Cell = UITableViewBridgeCell<Value>

  var cellType: UITableViewCell.Type { Cell.self }
}
