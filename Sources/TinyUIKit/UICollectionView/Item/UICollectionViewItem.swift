//
//  UICollectionViewItem.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UICollectionViewItem {
  
  // MARK: States
  
  public var id: String
  
  // MARK: Resolvers
  
  var cellProvider: CellProvider
  var updateCellHandler: UpdateCellHandler
  var sizeProvider: SizeProvider
  var onWillAppearHandler: OnWillAppearHandler?
  var onSelectHandler: OnSelectHandler?
}

extension UICollectionViewItem {
  public init<Content: UIViewRepresentable>(
    id: String? = nil,
    reuseIdentifier: String? = nil,
    content: Content,
    sizeProvider: @escaping SizeProvider
  ) {
    let reuseIdentifier = reuseIdentifier ?? String(describing: Cell.self)
    
    self.init(
      id: id ?? UUID().uuidString,
      cellProvider: { context in
        context.collectionView.register(
          Cell.self,
          forCellWithReuseIdentifier: reuseIdentifier
        )
        
        return context.collectionView.dequeueReusableCell(
          withReuseIdentifier: reuseIdentifier,
          for: context.indexPath
        ) as! Cell
      },
      updateCellHandler: { cell, itemContext in
        let cell = cell as! Cell
        
        // Prepare context for content view.
        let viewContext = Content.Context(
          coordinator: content.makeCoordinator(),
          environment: itemContext.environment
        )
        
        // Start to resolve content view.
        let contentView: Content.UIViewType
        
        if let bridgingView = cell.bridgingView {
          // Reuse the existing content view from the target cell.
          contentView = bridgingView
        } else {
          // Making a new content view.
          contentView = content.makeUIView(context: viewContext)
        }
        
        // Install content view on cell.
        if (contentView.superview === cell.contentView) {
          // Content view is already installed on the target cell.
        } else {
          cell.installBridgingView(contentView)
        }
        
        // Finish to resolve content view.
        
        // Update content view.
        content.updateUIView(contentView, context: viewContext)
      },
      sizeProvider: sizeProvider
    )
    
    // MARK: Helpers
    
    typealias Cell = UICollectionViewBridgingCell<Content.UIViewType>
  }
  
  public init<Content: UIViewRepresentable>(
    id: String? = nil,
    reuseIdentifier: String? = nil,
    content: Content,
    sizeProvider: UICollectionViewItemSizeProvider? = nil
  ) {
    self.init(
      id: id,
      reuseIdentifier: reuseIdentifier,
      content: content,
      sizeProvider: { itemContext in
        let sizeProvider: UICollectionViewItemSizeProvider = sizeProvider
          ?? .fittingCompressedSize
        
        // Prepare context for content view.
        let viewContext = Content.Context(
          coordinator: content.makeCoordinator(),
          environment: itemContext.environment
        )
        let view = content.makeUIView(context: viewContext)
        
        content.updateUIView(view, context: viewContext)
        
        return sizeProvider.collectionView(
          itemContext.collectionView,
          itemContext.collectionViewLayout,
          sizeFor: view,
          at: itemContext.indexPath
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
  public typealias SizeProvider = (Context) -> CGSize
  public typealias OnWillAppearHandler = (UICollectionViewCell, Context) -> Void
  public typealias OnSelectHandler = (UICollectionViewCell, Context) -> Void
}
