//
//  UICollectionViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import UIKit

public struct UICollectionViewSupplementary {
  var viewProvider: ViewProvider
  var updateViewHandler: UpdateViewHandler
  var sizeProvider: SizeProvider
  private(set) var onWillAppearHandler: OnWillAppearHandler?
}

extension UICollectionViewSupplementary {
  public init<Content: UIViewRepresentable>(
    reuseIdentifier: String? = nil,
    content: Content,
    contentForSizeProvider: Content? = nil,
    sizeProvider: @escaping SizeProvider
  ) {
    let reuseIdentifier = reuseIdentifier ?? String(describing: View.self)
    self.init(
      viewProvider: { context in
        switch context.viewProvidingTarget {
        case .sizeForSupplementary:
          return View()
        case .viewForSupplementary:
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
        }
      },
      updateViewHandler: { view, context in
        let view = view as! View
        let targetContent: Content
        switch context.viewProvidingTarget {
        case .sizeForSupplementary:
          targetContent = contentForSizeProvider ?? content
        case .viewForSupplementary:
          targetContent = content
        }
        view.updateUI(
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
    
    typealias View = UICollectionViewBridgingSupplementaryView<
      Content.UIViewType
    >
  }
  
  public init<Content: UIViewRepresentable>(
    reuseIdentifier: String? = nil,
    content: Content,
    contentForSizeProvider: Content? = nil,
    sizeProvider: UICollectionViewSupplementarySizeProvider? = nil
  ) {
    self.init(
      reuseIdentifier: reuseIdentifier,
      content: content,
      contentForSizeProvider: contentForSizeProvider,
      sizeProvider: { view, context in
        let sizeProvider: UICollectionViewSupplementarySizeProvider
          = sizeProvider ?? .fittingCompressedSize
        return sizeProvider.collectionView(
          context.collectionView,
          context.collectionViewLayout,
          elementKind: context.elementKind,
          sizeFor: view,
          at: context.indexPath
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
  public typealias SizeProvider = (
    UICollectionReusableView,
    Context
  ) -> CGSize
  public typealias OnWillAppearHandler = (UICollectionReusableView, Context) -> Void
}
