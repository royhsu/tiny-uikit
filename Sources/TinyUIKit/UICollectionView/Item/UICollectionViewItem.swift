//
//  UICollectionViewItem.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UICollectionViewItem {
  public var id: String
  var cellProvider: CellProvider
  var updateCellHandler: UpdateCellHandler
  var sizeProvider: SizeProvider
  private(set) var onWillAppearHandler: OnWillAppearHandler?
  private(set) var onSelectHandler: OnSelectHandler?
}

extension UICollectionViewItem {
  public init<Content: UIViewRepresentable>(
    id: String? = nil,
    reuseIdentifier: String? = nil,
    content: Content,
    contentForSizeProvider: Content? = nil,
    sizeProvider: @escaping SizeProvider
  ) {
    let reuseIdentifier = reuseIdentifier ?? String(describing: Cell.self)
    self.init(
      id: id ?? UUID().uuidString,
      cellProvider: { context in
        switch context.cellProvidingTarget {
        case .sizeForItem:
          return Cell()
        case .cellForItem:
          context.collectionView.register(
            Cell.self,
            forCellWithReuseIdentifier: reuseIdentifier
          )
          return context.collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: context.indexPath
          ) as! Cell
        }
      },
      updateCellHandler: { cell, context in
        let cell = cell as! Cell
        let targetContent: Content
        switch context.cellProvidingTarget {
        case .sizeForItem:
          targetContent = contentForSizeProvider ?? content
        case .cellForItem:
          targetContent = content
        }
        cell.updateUI(
          with: targetContent,
          context: Content.Context(
            coordinator: targetContent.makeCoordinator(),
            environment: context.environment
          )
        )
      },
      sizeProvider: sizeProvider
    )
    
    // MARK: Helpers
    
    typealias Cell = UICollectionViewBridgingCell<Content.UIViewType>
  }
  
  public init<Content: UIViewRepresentable>(
    reuseIdentifier: String? = nil,
    content: Content,
    contentForSizeProvider: Content? = nil,
    sizeProvider: UICollectionViewItemSizeProvider? = nil
  ) {
    self.init(
      reuseIdentifier: reuseIdentifier,
      content: content,
      contentForSizeProvider: contentForSizeProvider,
      sizeProvider: { cell, context in
        let sizeProvider: UICollectionViewItemSizeProvider = sizeProvider
          ?? .fittingCompressedSize
        return sizeProvider.collectionView(
          context.collectionView,
          context.collectionViewLayout,
          sizeFor: cell,
          at: context.indexPath
        )
      }
    )
  }
}

// MARK: - Modifiers

extension UICollectionViewItem {
  public func onWillAppear(
    perform handler: @escaping OnWillAppearHandler
  ) -> UICollectionViewItem {
    var newValue = self
    newValue.onWillAppearHandler = handler
    return newValue
  }
  
  public func onSelect(
    perform handler: @escaping OnSelectHandler
  ) -> UICollectionViewItem {
    var newValue = self
    newValue.onSelectHandler = handler
    return newValue
  }
}

// MARK: - Helpers

extension UICollectionViewItem {
  public typealias Context = UICollectionViewItemContext
  typealias CellProvider = (Context) -> UICollectionViewCell
  typealias UpdateCellHandler = (UICollectionViewCell, Context) -> Void
  public typealias SizeProvider = (UICollectionViewCell, Context) -> CGSize
  public typealias OnWillAppearHandler = (UICollectionViewCell, Context) -> Void
  public typealias OnSelectHandler = (UICollectionViewCell, Context) -> Void
}
