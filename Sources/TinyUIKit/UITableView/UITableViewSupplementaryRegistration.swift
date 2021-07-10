//
//  UITableViewSupplementaryRegistration.swift
//  
//
//  Created by Roy Hsu on 2021/7/10.
//

import UIKit

public protocol UITableViewSupplementaryRegistration {
  var reuseIdentifier: String { get }
  
  var supplementaryType: UITableViewHeaderFooterView.Type { get }
}
