//
//  UITableViewCellRegistrationManager.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UITableViewCellRegistrationManager {
  public let tableView: UITableView

  public init(tableView: UITableView) {
    self.tableView = tableView
  }
}

public extension UITableViewCellRegistrationManager {
  func registerAll<Registrations: Sequence>(
    _ registrations: Registrations
  ) where Registrations.Element == UITableViewCellRegistration {
    for registration in registrations {
      tableView.register(
        registration.cellType,
        forCellReuseIdentifier: registration.reuseIdentifier
      )
    }
  }
}
