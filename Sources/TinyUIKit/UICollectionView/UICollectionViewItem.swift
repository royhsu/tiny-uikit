//
//  UICollectionViewItem.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public struct UICollectionViewItem {
  private let _reuseIdentifier: () -> String
  private let _cellType: () -> UICollectionViewCell.Type
  private let _makeUICollectionViewCell: (Context) -> UICollectionViewCell
  private let _updateUICollectionViewCell
    : (UICollectionViewCell, Context) -> Void
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    content: Content,
    size: UICollectionViewLayoutSize? = nil,
    onSelect: (() -> Void)? = nil
  ) {
    typealias Cell = UICollectionViewBridgeCell<Content.UIViewType>
    
    let _reuseIdentifier = { String(describing: Cell.self) }
    self._reuseIdentifier = _reuseIdentifier
    self._cellType = { Cell.self }
    self._makeUICollectionViewCell = { context in
      let collectionView = context.coordinator.collectionView
      let reuseIdentifier = _reuseIdentifier()
      collectionView
        .register(Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: reuseIdentifier,
        for: context.coordinator.indexPath
      ) as! Cell
    }
    self._updateUICollectionViewCell = { cell, context in
      let cell = cell as! Cell
      let layoutInfoProvider: LayoutInfoProvider?
      if let size = size {
        layoutInfoProvider = {
          let collectionView = context.coordinator.collectionView
          let containerRect = collectionView.bounds
            .inset(by: collectionView.layoutMargins)
          return (containerRect.size, size)
        }
      } else {
        layoutInfoProvider = nil
      }
      cell.updateUI(
        with: content,
        layoutInfoProvider: layoutInfoProvider,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self.onSelect = onSelect
  }
  
  public func makeUICollectionViewCell(context: Context)
  -> UICollectionViewCell {
    _makeUICollectionViewCell(context)
  }

  public func updateUICollectionViewCell(
    _ cell: UICollectionViewCell,
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
    _cellType()
  }
}

// MARK: - Helpers

public extension UICollectionViewItem {
  typealias Context = UIViewRepresentableContext<Coordinator>
  typealias LayoutInfoProvider
    = () -> (containerSize: CGSize, itemSize: UICollectionViewLayoutSize)
  
  struct Coordinator {
    public var collectionView: UICollectionView
    public var indexPath: IndexPath

    public init(collectionView: UICollectionView, indexPath: IndexPath) {
      self.collectionView = collectionView
      self.indexPath = indexPath
    }
  }
}
