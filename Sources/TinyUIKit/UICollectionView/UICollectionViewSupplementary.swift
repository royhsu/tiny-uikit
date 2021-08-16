//
//  UICollectionViewSupplementary.swift
//  
//
//  Created by Roy Hsu on 2021/7/11.
//

import UIKit

public struct UICollectionViewSupplementary {
  public let elementKind: String
  private let _reuseIdentifier: () -> String
  private let _supplementaryViewType
    : () -> UICollectionViewSupplementaryView.Type
  private let _makeUICollectionViewSupplementaryView
    : (Context) -> UICollectionViewSupplementaryView
  private let _updateUICollectionViewSupplementaryView
    : (UICollectionViewSupplementaryView, Context) -> Void
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    elementKind: String
  ) {
    typealias SupplementaryView
      = UICollectionViewSupplementaryBridgeView<Content.UIViewType>
    
    let _reuseIdentifier = { String(describing: SupplementaryView.self) }
    self.elementKind = elementKind
    self._reuseIdentifier = _reuseIdentifier
    self._supplementaryViewType = { SupplementaryView.self }
    self._makeUICollectionViewSupplementaryView = { context in
      let collectionView = context.coordinator.collectionView
      let reuseIdentifier = _reuseIdentifier()
      collectionView.register(
        SupplementaryView.self,
        forSupplementaryViewOfKind: elementKind,
        withReuseIdentifier: reuseIdentifier
      )
      let view = collectionView.dequeueReusableSupplementaryView(
        ofKind: elementKind,
        withReuseIdentifier: reuseIdentifier,
        for: context.coordinator.indexPath
      )
      as! SupplementaryView
      return view
    }
    self._updateUICollectionViewSupplementaryView = { view, context in
      let view = view as! SupplementaryView
      view.updateUI(
        with: content,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
  }

  public func makeUICollectionViewSupplementaryView(context: Context)
  -> UICollectionViewSupplementaryView {
    _makeUICollectionViewSupplementaryView(context)
  }
  
  public func updateUICollectionViewSupplementaryView(
    _ view: UICollectionViewSupplementaryView,
    context: Context
  ) {
    _updateUICollectionViewSupplementaryView(view, context)
  }
  
  public var reuseIdentifier: String {
    _reuseIdentifier()
  }
  
  public var supplementaryType: UICollectionViewSupplementaryView.Type {
    _supplementaryViewType()
  }
}

// MARK: - Helpers

extension UICollectionViewSupplementary {
  public typealias Context = UIViewRepresentableContext<Coordinator>
  
  public struct Coordinator {
    public var collectionView: UICollectionView
    public var indexPath: IndexPath
    
    public init(
      collectionView: UICollectionView,
      indexPath: IndexPath
    ) {
      self.collectionView = collectionView
      self.indexPath = indexPath
    }
  }
}

public typealias UICollectionViewSupplementaryView = UICollectionReusableView
