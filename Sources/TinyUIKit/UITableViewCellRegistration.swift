//
//  UITableViewCellRegistration.swift
//  
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public protocol UITableViewCellRegistration {
  var reuseIdentifier: String { get }
  var cellType: UITableViewCell.Type { get }
}
