//
//  ContactListController.swift
//  Demo
//
//  Created by Roy Hsu on 2021/7/10.
//

import TinyUIKit
import UIKit

final class ContactListController: UIViewController {
  private let contentViewController = UITableViewBridgeController<Void>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentViewController.sections = [
      .init(items: [
        .init(content: UIContactRow()),
        .init(content: UIContactNameTextField()),
        .init(content: UIContactRow()),
        .init(content: UIContactNameTextField()),
        .init(content: UIContactRow()),
      ])
    ]
    contentViewController.tableView.reloadData()
    
    addChild(contentViewController)
    
    let contentView = contentViewController.view!
    
    // Layout.
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)
    NSLayoutConstraint.activate([
      // Horizontal.
      contentView.leadingAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      contentView.trailingAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      
      // Vertical.
      contentView.topAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      contentView.bottomAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    contentViewController.didMove(toParent: self)
  }
}

struct UIContactRow: UIViewRepresentable {
  func makeUIView(context: Context) -> UILabel {
    UILabel()
  }
  
  func updateUIView(_ label: UILabel, context: Context) {
    label.text = "Katherine"
  }
  
  typealias Coordinator = Void
}

struct UIContactNameTextField: UIViewRepresentable {
  func makeUIView(context: Context) -> UITextField {
    UITextField()
  }
  
  func updateUIView(_ textField: UITextField, context: Context) {
    textField.borderStyle = .roundedRect
  }
  
  typealias Coordinator = Void
}

