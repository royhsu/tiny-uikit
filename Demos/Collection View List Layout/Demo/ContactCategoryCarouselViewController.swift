//
//  ContactCategoryCarouselViewController.swift
//  Demo
//
//  Created by Roy Hsu on 2023/6/25.
//

import TinyUIKit
import UIKit

final class ContactCategoryCarouselViewController: UIViewController {
  private lazy var rootContentFlowLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
    return layout
  }()
  private lazy var rootContentViewController
    = UICollectionViewBridgingController(
        collectionViewLayout: rootContentFlowLayout
      )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    installRootContentViewController()
    updateUI()
  }
  
  func updateUI() {
    rootContentViewController.collectionView.layoutMargins = .zero
    rootContentViewController.sections = [
      Section(
        items: [
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _ in CGSize(width: 200.0, height: 150.0) }
          ),
        ]
      )
    ]
    rootContentViewController.collectionView.backgroundColor = .purple
    rootContentViewController.collectionView.reloadData()
  }
}

// MARK: - Sections

extension ContactCategoryCarouselViewController {
  typealias Section = UICollectionViewBridgingController.Section
  typealias Item = UICollectionViewBridgingController.Item
}

// MARK: - Helpers

extension ContactCategoryCarouselViewController {
  private func installRootContentViewController() {
    addChild(rootContentViewController)
    
    // Handle layout.
    let contentView = rootContentViewController.view!
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)
    
    // Install active constraints.
    NSLayoutConstraint.activate([
      // Horizontal axis.
      contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
      // Vertical axis.
      contentView.topAnchor.constraint(equalTo: view.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    rootContentViewController.didMove(toParent: self)
  }
}
