//
//  UICollectionViewCellRepresentable.swift
//  
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public protocol UICollectionViewCellRepresentable {
  associatedtype Cell: UICollectionViewCell
  typealias Coordinator = UICollectionViewCellRepresentableCoordinator
  typealias Context = UIViewRepresentableContext<Coordinator>
  
  var reuseIdentifier: String { get }
  
  var cellType: UITableViewCell.Type { get }
  
  /// Default implementation provided.
  func makeUICell(context: Context) -> Cell
  
  func updateUICell(_ cell: Cell, context: Context)
}

extension UICollectionViewCellRepresentable {
  public func makeUICell(context: Context) -> Cell {
    context.coordinator.collectionView.dequeueReusableCell(
      withReuseIdentifier: reuseIdentifier,
      for: context.coordinator.indexPath
    ) as! Cell
  }
}
