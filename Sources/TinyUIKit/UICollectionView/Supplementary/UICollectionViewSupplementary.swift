//
//  UICollectionViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import UIKit

public struct UICollectionViewSupplementary {
  let viewProvider: ViewProvider
  let updateViewHandler: UpdateViewHandler
  let sizeProvider: SizeProvider?
  
  public init<Content: UIViewRepresentable>(
    reuseIdentifier reuseIdentifierProvider: ReuseIdentifierProvider? = nil,
    content: Content,
    size sizeProvider: SizeProvider? = nil
  ) {
    self.viewProvider = { context in
      switch context.viewProvidingStrategy {
      case .new:
        return View()
      case .reused:
        let identifier = reuseIdentifierProvider?(context)
          ?? String(describing: View.self)
        context.collectionView.register(
          View.self,
          forSupplementaryViewOfKind: context.elementKind,
          withReuseIdentifier: identifier
        )
        return context.collectionView.dequeueReusableSupplementaryView(
          ofKind: context.elementKind,
          withReuseIdentifier: identifier,
          for: context.indexPath
        ) as! View
      }
    }
    self.updateViewHandler = { view, context in
      let view = view as! View
      view.updateUI(
        with: content,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self.sizeProvider = sizeProvider
    
    // MARK: Helpers
    
    typealias View = UICollectionViewBridgingSupplementaryView<
      Content.UIViewType
    >
  }
}

// MARK: - Helpers

extension UICollectionViewSupplementary {
  public typealias Context = UICollectionViewSupplementaryContext
  public typealias ReuseIdentifierProvider = (Context) -> String
  typealias ViewProvider = (Context) -> UICollectionReusableView
  typealias UpdateViewHandler = (
    UICollectionReusableView,
    Context
  ) -> Void
  public typealias SizeProvider = (
    UICollectionReusableView,
    Context
  ) -> CGSize?
}
