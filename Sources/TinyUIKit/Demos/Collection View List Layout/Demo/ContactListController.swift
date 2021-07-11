//
//  ContactListController.swift
//  Demo
//
//  Created by Roy Hsu on 2021/7/10.
//

import TinyUIKit
import UIKit

final class ContactListController: UIViewController {
//  private let contentViewController = UITableViewBridgeController<Void>()
  private let listLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    return layout
  }()
  private lazy var contentViewController =
    UICollectionViewBridgeController<Void>(collectionViewLayout: listLayout)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentViewController.collectionView.layoutMargins = .zero
    contentViewController.sections = [
      .init(items: [
        .init(
          content: UIContactRow(),
          size: UICollectionViewLayoutSize(
            width: 200.0,
            height: 100.0
          )
        ),
        .init(
          content: UIContactRow(),
          size: UICollectionViewLayoutSize(
            width: 1.0,
            widthDimension: .fractionalWidth,
            height: 44.0,
            heightDimension: .estimated
          )
        ),
        .init(
          content: UIContactRow(),
          size: UICollectionViewLayoutSize(
            width: 140.0,
            height: 60.0
          )
        ),
        .init(
          content: UIContactRow(),
          size: UICollectionViewLayoutSize(
            width: 140.0,
            height: 60.0
          )
        ),
        .init(content: UIContactRow()),
        .init(content: UIContactRow()),
        .init(content: UIContactRow()),
        .init(content: UIContactRow()),
//        .init(content: UIContactNameTextField()),
        .init(content: UIContactRow()),
//        .init(content: UIContactNameTextField()),
        .init(content: UIContactRow()),
      ])
    ]
//    contentViewController.tableView.reloadData()
    contentViewController.collectionView.backgroundColor = .white
    contentViewController.collectionView.reloadData()
    
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
  
  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate { context in
      self.contentViewController.collectionViewLayout.invalidateLayout()
    } completion: { context in }
  }
}

struct UIContactRow: UIViewRepresentable {
  func makeUIView(context: Context) -> UILabel {
    UILabel()
  }
  
  func updateUIView(_ label: UILabel, context: Context) {
    label.text = "Katherine\nKatherine\nKatherine\nKatherine"
    label.numberOfLines = 0
    label.backgroundColor = .red
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

