//
//  UICollectionViewBridgeController.swift
//
//
//  Created by Roy Hsu on 2021/6/17.
//

import UIKit

open class UICollectionViewBridgeController<Coordinator>
: UICollectionViewController {
  
  // MARK: Data Source
  
  public var sections: [Section] = []
  
  public override init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(collectionViewLayout: layout)
    self.setUp()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setUp()
  }
  
  // MARK: View Lifecycle
  
  private func setUp() {}
  
  // MARK: UICollectionViewDataSource
  
  public override func numberOfSections(in collectionView: UICollectionView)
  -> Int {
    sections.count
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    sections[section].items.count
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let item = sections[indexPath.section].items[AnyIndex(indexPath.row)]
    collectionView.register(item)
    
    let context = Item.Context(
      coordinator: Item.Coordinator(
        collectionView: collectionView,
        indexPath: indexPath
      ),
      environment: environment
    )
    let cell = item.makeUICollectionViewCell(context: context)
    item.updateUICollectionViewCell(cell, context: context)
    
    return cell
  }
  
  // MARK: UICollectionViewDelegate
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let item = sections[indexPath.section].items[AnyIndex(indexPath.row)]
    item.onSelect?()
  }
}

// MARK: - Helpers

extension UICollectionViewBridgeController {
  public typealias Item = UICollectionViewItem<UIView>
  
  public struct Section {
    public var items: AnyCollection<Item>
    
    public init<C: Collection>(items: C)
    where C.Element == Item, C.Index == Int {
      self.items = AnyCollection(items)
    }
  }
  
  private var environment: UIEnvironmentValues {
    UIEnvironmentValues(traitCollection: traitCollection)
  }
}
