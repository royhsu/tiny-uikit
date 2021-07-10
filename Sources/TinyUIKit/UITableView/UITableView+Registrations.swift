//
//  UITableView+Registrations.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public extension UITableView {
  func register<Registration: UITableViewCellRegistration>(
    _ registration: Registration
  ) {
    register(
      registration.cellType,
      forCellReuseIdentifier: registration.reuseIdentifier
    )
  }
  
  func register<Registration: UITableViewSupplementaryRegistration>(
    _ registration: Registration
  ) {
    register(
      registration.supplementaryType,
      forHeaderFooterViewReuseIdentifier: registration.reuseIdentifier
    )
  }
}
