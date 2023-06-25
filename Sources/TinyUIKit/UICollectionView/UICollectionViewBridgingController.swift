//
//  UICollectionViewBridgingController.swift
//
//
//  Created by Roy Hsu on 2021/6/17.
//

import UIKit

open class UICollectionViewBridgingController
: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  // MARK: States
  
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
  
  private func setUp() {
    collectionView.register(
      UICollectionViewUnknownCell.self,
      forCellWithReuseIdentifier: UICollectionViewUnknownCell.reuseIdentifier
    )
    collectionView.register(
      UICollectionViewUnknownSupplementaryView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: UICollectionViewUnknownSupplementaryView
        .reuseIdentifier
    )
    collectionView.register(
      UICollectionViewUnknownSupplementaryView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
      withReuseIdentifier: UICollectionViewUnknownSupplementaryView
        .reuseIdentifier
    )
  }
  
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
    guard let item = validItem(at: indexPath) else {
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: UICollectionViewUnknownCell.reuseIdentifier,
        for: indexPath
      )
    }
    
    // Prepare context for item.
    let context = Item.Context(
      indexPath: indexPath,
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    let cell = item.cellProvider(context)
    item.updateCellHandler(cell, context)
    
    return cell
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard let section = validSection(atIndex: indexPath.section) else {
      return dequeueUnknownSupplementaryView()
    }
    
    // Prepare context for item.
    let context = Supplementary.Context(
      viewProvidingTarget: .viewForSupplementary,
      elementKind: kind,
      indexPath: indexPath,
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let header = section.header else {
        return dequeueUnknownSupplementaryView()
      }
      
      let view = header.viewProvider(context)
      header.updateViewHandler(view, context)
      
      return view
    case UICollectionView.elementKindSectionFooter:
      guard let footer = section.footer else {
        return dequeueUnknownSupplementaryView()
      }
      
      let view = footer.viewProvider(context)
      footer.updateViewHandler(view, context)
      
      return view
    default:
      return dequeueUnknownSupplementaryView()
    }
    
    // MARK: Helpers
    
    func dequeueUnknownSupplementaryView() -> UICollectionReusableView {
      collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: UICollectionViewUnknownSupplementaryView
          .reuseIdentifier,
        for: indexPath
      )
    }
  }
  
  // MARK: UICollectionViewDelegate
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let item = validItem(at: indexPath) else { return }
    
    // Prepare context for item.
    let context = Item.Context(
      indexPath: indexPath,
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    item.onWillAppearHandler?(cell, context)
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    willDisplaySupplementaryView view: UICollectionReusableView,
    forElementKind elementKind: String,
    at indexPath: IndexPath
  ) {
    guard let section = validSection(atIndex: indexPath.section) else { return }
    
    // Prepare context for item.
    let context = Supplementary.Context(
      viewProvidingTarget: .viewForSupplementary,
      elementKind: elementKind,
      indexPath: indexPath,
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    
    switch elementKind {
    case UICollectionView.elementKindSectionHeader:
      guard let header = section.header else { return }
      
      header.onWillAppearHandler?(view, context)
    case UICollectionView.elementKindSectionFooter:
      guard let footer = section.footer else { return }
      
      footer.onWillAppearHandler?(view, context)
    default:
      return
    }
  }
  
  public override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let item = validItem(at: indexPath),
          let cell = collectionView.cellForItem(at: indexPath)
    else { return }
    
    // Prepare context for item.
    let context = Item.Context(
      indexPath: indexPath,
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    
    item.onSelectHandler?(cell, context)
  }
  
  // MARK: UICollectionViewDelegateFlowLayout
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let item = validItem(at: indexPath) else { return .zero }
    
    // Prepare context for item.
    let context = Item.Context(
      indexPath: indexPath,
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    
    return item.sizeProvider(context)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    guard let header = validSection(atIndex: section)?.header else {
      return .zero
    }
    
    // Prepare context for item.
    // There is only one header in a section so it's ok to use the first item
    // index path as reference for whole section.
    let context = Supplementary.Context(
      viewProvidingTarget: .sizeForSupplementary,
      elementKind: UICollectionView.elementKindSectionHeader,
      indexPath: IndexPath(item: 0, section: section),
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    let view = header.viewProvider(context)
    header.updateViewHandler(view, context)
    
    return header.sizeProvider(view, context)
  }
  
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int
  ) -> CGSize {
    guard let footer = validSection(atIndex: section)?.footer else {
      return .zero
    }
    
    // Prepare context for item.
    // There is only one footer in a section so it's ok to use the first item
    // index path as reference for whole section.
    let context = Supplementary.Context(
      viewProvidingTarget: .sizeForSupplementary,
      elementKind: UICollectionView.elementKindSectionFooter,
      indexPath: IndexPath(item: 0, section: section),
      collectionView: collectionView,
      collectionViewLayout: collectionViewLayout,
      environment: environment
    )
    let view = footer.viewProvider(context)
    footer.updateViewHandler(view, context)
    
    return footer.sizeProvider(view, context)
  }
}

// MARK: - Helpers

extension UICollectionViewBridgingController {
  public typealias Item = UICollectionViewItem
  public typealias Supplementary = UICollectionViewSupplementary
  
  public struct Section {
    public var id: String
    public var header: Supplementary?
    public var items: [Item]
    public var footer: Supplementary?
    public var decorations: [Supplementary]
    
    public init(
      id: String? = nil,
      header: Supplementary? = nil,
      items: [Item],
      footer: Supplementary? = nil,
      decorations: [Supplementary]? = nil
    ) {
      self.id = id ?? UUID().uuidString
      self.header = header
      self.items = items
      self.footer = footer
      self.decorations = decorations ?? []
    }
  }
  
  /// Access a valid section if the given index is within bounds of `sections`. But if the index is out of
  /// bounds, the function will return nil instead.
  private func validSection(atIndex index: Int) -> Section? {
    guard (index < sections.count) else { return nil }
    
    return sections[index]
  }
  
  /// Access a valid item if the given index path is within bounds of `sections`. But if the index path is out
  /// of bounds, the function will return nil instead.
  private func validItem(at indexPath: IndexPath) -> Item? {
    guard let section = validSection(atIndex: indexPath.section),
          (indexPath.item < section.items.count) else {
      return nil
    }
    
    return section.items[indexPath.item]
  }
}
