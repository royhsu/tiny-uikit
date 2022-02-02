//
//  UICollectionViewBridgeController.swift
//
//
//  Created by Roy Hsu on 2021/6/17.
//

import UIKit

open class UICollectionViewBridgeController<Coordinator>
: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
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
    guard indexPath.section < sections.count else {
      return UICollectionViewCell()
    }
    let section = sections[indexPath.section]
    guard indexPath.item < section.items.count else {
      return UICollectionViewCell()
    }
    let item = section.items[AnyIndex(indexPath.item)]
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
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard indexPath.section < sections.count else { return }
    let section = sections[indexPath.section]
    guard indexPath.item < section.items.count else { return }
    let item = section.items[AnyIndex(indexPath.item)]
    item.onWillAppear?()
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard indexPath.section < sections.count else { return }
    let section = sections[indexPath.section]
    guard indexPath.item < section.items.count else { return }
    let item = section.items[AnyIndex(indexPath.item)]
    item.onSelect?()
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let defaultSize = CGSize(width: 44.0, height: 44.0)
    guard indexPath.section < sections.count else { return defaultSize }
    let section = sections[indexPath.section]
    guard indexPath.item < section.items.count else { return defaultSize }
    let item = section.items[AnyIndex(indexPath.item)]
    let context = Item.Context(
      coordinator: Item.Coordinator(
        collectionView: collectionView,
        indexPath: indexPath
      ),
      environment: environment
    )
    let cell = item.makeUICollectionViewCell(context: context)
    item.updateUICollectionViewCell(cell, context: context)
    return item.sizeProvider?(cell, context) ?? defaultSize
  }
}

// MARK: - Helpers

extension UICollectionViewBridgeController {
  public typealias Item = UICollectionViewItem
  public typealias Supplementary = UICollectionViewSupplementary
  
  public struct Section {
    public var id: String
    public var header: Supplementary?
    public var items: AnyCollection<Item>
    public var footer: Supplementary?
    public var decorations: [Supplementary]
    
    public init<C: Collection>(
      id: String? = nil,
      header: Supplementary? = nil,
      items: C,
      footer: Supplementary? = nil,
      decorations: [Supplementary]? = nil
    ) where C.Element == Item, C.Index == Int {
      self.id = id ?? UUID().uuidString
      self.header = header
      self.items = AnyCollection(items)
      self.footer = footer
      self.decorations = decorations ?? []
    }
  }
  
  private var environment: UIEnvironmentValues {
    UIEnvironmentValues(traitCollection: traitCollection)
  }
}

extension UICollectionViewFlowLayout {
  public var containerRect: CGRect {
    guard let collectionView = collectionView else {
      return .zero
    }
    return collectionView.frame.inset(by: sectionInset)
  }
  
  /// The perferred item width for the given column count.
  public func preferredItemWidth(columnCount: Int) -> CGFloat {
    precondition(columnCount > 0)
    let interitemSpacingCount = columnCount - 1
    let totalSpacingForInteritems
      = minimumInteritemSpacing * CGFloat(interitemSpacingCount)
    let width
      = (containerRect.width - totalSpacingForInteritems) / CGFloat(columnCount)
    // Rounded for pixel-perfect point.
    // Use rounded down value can also make sure the number of columns generated
    // by collection view matches the `columnCount` argument.
    return width.rounded(.down)
  }
}
