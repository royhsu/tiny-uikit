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
    didSelectItemAt indexPath: IndexPath
  ) {
    guard indexPath.section < sections.count else { return }
    let section = sections[indexPath.section]
    guard indexPath.item < section.items.count else { return }
    let item = section.items[AnyIndex(indexPath.item)]
    item.onSelect?()
  }
  
//  public func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    referenceSizeForHeaderInSection sectionIndex: Int
//  ) -> CGSize {
//    let section = sections[sectionIndex]
//    guard let header = section.header, !section.items.isEmpty else {
//      return .zero
//    }
//    return CGSize(width: 100.0, height: 100.0)
//    let firstItemIndexPath = IndexPath(item: 0, section: sectionIndex)
//    let headerView = collectionView.supplementaryView(forElementKind: header.elementKind, at: firstItemIndexPath)
//    let headerView = self.collectionView(
//      collectionView,
//      viewForSupplementaryElementOfKind: header.elementKind,
//      at: firstItemIndexPath
//    )
//    return headerView
//      .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//  }
  
  #warning("TODO: [Priority: high] handle layout size for header. (header)")
  #warning("TODO: [Priority: high] handle layout size for footer. (header)")
  
//  public override func collectionView(
//    _ collectionView: UICollectionView,
//    viewForSupplementaryElementOfKind kind: String,
//    at indexPath: IndexPath
//  ) -> UICollectionReusableView {
//    print(#function, indexPath)
//    if kind == UICollectionView.elementKindSectionHeader {
//      let view = collectionView.dequeueReusableSupplementaryView(
//        ofKind: UICollectionView.elementKindSectionHeader,
//        withReuseIdentifier: "Header",
//        for: indexPath
//      ) as! BlueView
//      view.translatesAutoresizingMaskIntoConstraints = false
//      let containerSize = collectionView.bounds
//        .inset(by: collectionView.layoutMargins)
//      view.preferredMaxLayoutWidth = containerSize.width
//      return view
//    } else {
//      fatalError()
//    }
//    let section = sections[indexPath.section]
//    let context = UICollectionViewSupplementary.Context(
//      coordinator: UICollectionViewSupplementary.Coordinator(
//        collectionView: collectionView,
//        indexPath: indexPath
//      ),
//      environment: environment
//    )
//    if let header = section.header, header.elementKind == kind {
//      let headerView = header
//        .makeUICollectionViewSupplementaryView(context: context)
//      header
//        .updateUICollectionViewSupplementaryView(headerView, context: context)
//      return headerView
//    } else if let footer = section.footer, footer.elementKind == kind {
//      let footerView = footer
//        .makeUICollectionViewSupplementaryView(context: context)
//      footer
//        .updateUICollectionViewSupplementaryView(footerView, context: context)
//      return footerView
//    } else if let decoration
//      = section.decorations.first(where: { $0.elementKind == kind }) {
//      let decorationView = decoration
//        .makeUICollectionViewSupplementaryView(context: context)
//      decoration.updateUICollectionViewSupplementaryView(
//        decorationView,
//        context: context
//      )
//      return decorationView
//    } else {
//      assertionFailure("Unknown supplementary kind: \(kind)")
//      let invisibleView = UICollectionReusableView()
//      invisibleView.frame = .zero
//      return invisibleView
//    }
//  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
//  public func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    estimatedSizeForItemAt indexPath: IndexPath
//  ) -> CGSize {
//    let item = sections[indexPath.section].items[AnyIndex(indexPath.item)]
//    let context = Item.Context(
//      coordinator: Item.Coordinator(
//        collectionView: collectionView,
//        indexPath: indexPath
//      ),
//      environment: environment
//    )
//    let cell = item.makeUICollectionViewCell(context: context)
//    return item.estimatedSizeProvider?(cell) ?? .zero
//  }

//  public func collectionView(
//    _ collectionView: UICollectionView,
//    layout collectionViewLayout: UICollectionViewLayout,
//    sizeForItemAt indexPath: IndexPath
//  ) -> CGSize {
//    let item = sections[indexPath.section].items[AnyIndex(indexPath.item)]
//    let context = Item.Context(
//      coordinator: Item.Coordinator(
//        collectionView: collectionView,
//        indexPath: indexPath
//      ),
//      environment: environment
//    )
//    let cell = item.makeUICollectionViewCell(context: context)
//    return item.sizeProvider?(cell) ?? CGSize(width: 44.0, height: 44.0)
//  }
}

// MARK: - Helpers

extension UICollectionViewBridgeController {
  public typealias Item = UICollectionViewItem
  public typealias Supplementary = UICollectionViewSupplementary
  
  public struct Section {
    public var header: Supplementary?
    public var items: AnyCollection<Item>
    public var footer: Supplementary?
    public var decorations: [Supplementary]
    
    public init<C: Collection>(
      header: Supplementary? = nil,
      items: C,
      footer: Supplementary? = nil,
      decorations: [Supplementary]? = nil
    ) where C.Element == Item, C.Index == Int {
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
