//
//  UICollectionViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import UIKit

public struct UICollectionViewSupplementary {
  
  // MARK: States
  
  public var id: String
  
  // MARK: Resolvers
  
  var viewProvider: ViewProvider
  var updateViewHandler: UpdateViewHandler
  var sizeProvider: SizeProvider
  var onWillAppearHandler: OnWillAppearHandler?
}

extension UICollectionViewSupplementary {
  public init<Content: UIViewRepresentable>(
    id: String? = nil,
    reuseIdentifier: String? = nil,
    content: Content,
    sizeProvider: @escaping SizeProvider
  ) {
    let reuseIdentifier = reuseIdentifier ?? String(describing: View.self)
    
    self.init(
      id: id ?? UUID().uuidString,
      viewProvider: { context in
        context.collectionView.register(
          View.self,
          forSupplementaryViewOfKind: context.elementKind,
          withReuseIdentifier: reuseIdentifier
        )
        
        return context.collectionView.dequeueReusableSupplementaryView(
          ofKind: context.elementKind,
          withReuseIdentifier: reuseIdentifier,
          for: context.indexPath
        ) as! View
      },
      updateViewHandler: { view, itemContext in
        let view = view as! View
        
        // Prepare context for content view.
        let viewContext = Content.Context(
          coordinator: content.makeCoordinator(),
          environment: itemContext.environment
        )
        
        // Start to resolve content view.
        let contentView: Content.UIViewType
        
        if let bridgingView = view.bridgingView {
          // Reuse the existing content view from the target cell.
          contentView = bridgingView
        } else {
          // Making a new content view.
          contentView = content.makeUIView(context: viewContext)
        }
        
        // Install content view on cell.
        if (contentView.superview === view) {
          // Content view is already installed on the target cell.
        } else {
          view.installBridgingView(contentView)
        }
        
        // Finish to resolve content view.
        
        // Update content view.
        content.updateUIView(contentView, context: viewContext)
      },
      sizeProvider: sizeProvider
    )
    
    // MARK: Helpers
    
    typealias View = UICollectionViewBridgingSupplementaryView<
      Content.UIViewType
    >
  }
  
  public init<Content: UIViewRepresentable>(
    id: String? = nil,
    reuseIdentifier: String? = nil,
    content: Content,
    sizeProvider: UICollectionViewSupplementarySizeProvider? = nil
  ) {
    self.init(
      id: id,
      reuseIdentifier: reuseIdentifier,
      content: content,
      sizeProvider: { itemContext in
        let sizeProvider: UICollectionViewSupplementarySizeProvider
          = sizeProvider ?? .fittingCompressedSize
        
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
          elementKind: itemContext.elementKind,
          sizeFor: view,
          at: itemContext.indexPath
        )
      }
    )
  }
}

// MARK: - Modifiers

extension UICollectionViewSupplementary {
  public func onWillAppear(
    perform handler: @escaping OnWillAppearHandler
  ) -> UICollectionViewSupplementary {
    var newValue = self
    newValue.onWillAppearHandler = handler
    
    return newValue
  }
}

// MARK: - Helpers

extension UICollectionViewSupplementary {
  public typealias Context = UICollectionViewSupplementaryContext
  typealias ViewProvider = (Context) -> UICollectionReusableView
  typealias UpdateViewHandler = (
    UICollectionReusableView,
    Context
  ) -> Void
  public typealias SizeProvider = (Context) -> CGSize
  public typealias OnWillAppearHandler = (UICollectionReusableView, Context)
  -> Void
}
