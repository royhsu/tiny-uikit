//
//  UITableViewCellCoordinator.swift
//
//
//  Created by Roy Hsu on 2021/6/12.
//

import UIKit

public struct UITableViewCellCoordinator {
  public var tableView: UITableView
  public var indexPath: IndexPath

  public init(tableView: UITableView, indexPath: IndexPath) {
    self.tableView = tableView
    self.indexPath = indexPath
  }
}
