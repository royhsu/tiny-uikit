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
  public var sizeProvider: SizeProvider?
  public var onWillAppear: (() -> Void)?
  public var onSelect: (() -> Void)?
  
  public init<Content: UIViewRepresentable>(
    reuseIdentifier reuseIdentifierProvider: (() -> String)? = nil,
    content: Content,
    sizeProvider: SizeProvider? = nil,
    onWillAppear: (() -> Void)? = nil,
    onSelect: (() -> Void)? = nil
  ) {
    typealias Cell = UICollectionViewBridgeCell<Content.UIViewType>
    
    let _reuseIdentifier = reuseIdentifierProvider
      ?? { String(describing: Cell.self) }
    self._reuseIdentifier = _reuseIdentifier
    self._cellType = { Cell.self }
    self._makeUICollectionViewCell = { context in
      switch context.coordinator.cellUsage {
      case .template:
        return Cell()
      case .display:
        let collectionView = context.coordinator.collectionView
        let reuseIdentifier = _reuseIdentifier()
        collectionView
          .register(Cell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return collectionView.dequeueReusableCell(
          withReuseIdentifier: reuseIdentifier,
          for: context.coordinator.indexPath
        ) as! Cell
      }
    }
    self._updateUICollectionViewCell = { cell, context in
      let cell = cell as! Cell
      cell.updateUI(
        with: content,
        context: Content.Context(
          coordinator: content.makeCoordinator(),
          environment: context.environment
        )
      )
    }
    self.sizeProvider = sizeProvider
    self.onWillAppear = onWillAppear
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

extension UICollectionViewItem {
  public typealias Context = UIViewRepresentableContext<Coordinator>
  public typealias SizeProvider = (UICollectionViewCell, Context) -> CGSize?
  
  public struct Coordinator {
    public enum CellUsage {
      case template, display
    }
    public var cellUsage: CellUsage
    public var collectionView: UICollectionView
    public var indexPath: IndexPath

    public init(
      cellUsage: CellUsage,
      collectionView: UICollectionView,
      indexPath: IndexPath
    ) {
      self.cellUsage = cellUsage
      self.collectionView = collectionView
      self.indexPath = indexPath
    }
  }
}
