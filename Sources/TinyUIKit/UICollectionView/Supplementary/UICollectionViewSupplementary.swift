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
}

extension UICollectionViewSupplementary {
  public init<Content: UIViewRepresentable>(
    reuseIdentifier: String? = nil,
    content: Content,
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
        view.updateUI(
          with: content,
          context: Content.Context(
            coordinator: content.makeCoordinator(),
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
}
