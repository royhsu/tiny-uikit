//
//  UITableViewCellRepresentable.swift
//  
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public protocol UITableViewCellRepresentable: UITableViewCellRegistration {
  associatedtype Cell: UITableViewCell
  typealias Coordinator = UITableViewCellRepresentableCoordinator
  typealias Context = UIViewRepresentableContext<Coordinator>
  
  /// Default implementation provided.
  func makeUICell(context: Context) -> Cell
  
  func updateUICell(_ cell: Cell, context: Context)
}

extension UITableViewCellRepresentable {
  public func makeUICell(context: Context) -> Cell {
    context.coordinator.tableView.dequeueReusableCell(
      withIdentifier: reuseIdentifier,
      for: context.coordinator.indexPath
    ) as! Cell
  }
}
