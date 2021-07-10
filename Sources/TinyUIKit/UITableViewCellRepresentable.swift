//
//  UITableViewCellRepresentable.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

@available(*, deprecated)
public protocol UITableViewCellRepresentable: UITableViewCellRegistration {
  associatedtype UITableViewCellType: UITableViewCell
  typealias Coordinator = UITableViewCellCoordinator
  typealias Context = UIViewRepresentableContext<Coordinator>

  /// Default implementation provided.
  func makeUICell(context: Context) -> UITableViewCellType

  func updateUITableViewCell(_ cell: UITableViewCellType, context: Context)
}

public extension UITableViewCellRepresentable {
  func makeUICell(context: Context) -> UITableViewCellType {
    context.coordinator.tableView.dequeueReusableCell(
      withIdentifier: reuseIdentifier,
      for: context.coordinator.indexPath
    ) as! UITableViewCellType
  }
}
