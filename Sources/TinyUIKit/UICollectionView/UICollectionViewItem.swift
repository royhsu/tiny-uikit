//
//  UICollectionViewItem.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UICollectionViewItem<UIViewType: UIView> {
  private let _reuseIdentifier: () -> String
  private let _makeUICollectionViewCell: (Context) -> UICollectionViewCellType
  private let _updateUICollectionViewCell
    : (UICollectionViewCellType, Context) -> Void
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    onSelect: (() -> Void)? = nil
  ) where Content.UIViewType == UIViewType {
    let _reuseIdentifier = { String(describing: UICollectionViewCellType.self) }
    self._reuseIdentifier = _reuseIdentifier
    self._makeUICollectionViewCell = { context in
      context.coordinator.collectionView.dequeueReusableCell(
        withReuseIdentifier: _reuseIdentifier(),
        for: context.coordinator.indexPath
      ) as! UICollectionViewCellType
    }
    self._updateUICollectionViewCell = { cell, context in
      cell.updateUI(
        with: content,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self.onSelect = onSelect
  }
  
  public func makeUICollectionViewCell(context: Context)
  -> UICollectionViewCellType {
    _makeUICollectionViewCell(context)
  }

  public func updateUICollectionViewCell(
    _ cell: UICollectionViewCellType,
    context: Context
  ) {
    _updateUICollectionViewCell(cell, context)
  }
}

// MARK: - UICollectionViewCellRegistration

extension UICollectionViewItem: UICollectionViewCellRegistration {
  public var reuseIdentifier: String {
    _reuseIdentifier()
  }

  public var cellType: UICollectionViewCell.Type {
    UICollectionViewCellType.self
  }
}

public extension UICollectionViewItem {
  typealias UICollectionViewCellType = UICollectionViewBridgeCell<UIViewType>
  typealias Context = UIViewRepresentableContext<Coordinator>
  
  struct Coordinator {
    public var collectionView: UICollectionView
    public var indexPath: IndexPath

    public init(collectionView: UICollectionView, indexPath: IndexPath) {
      self.collectionView = collectionView
      self.indexPath = indexPath
    }
  }
}
