////
////  UICollectionViewBridgeController.swift
////  
////
////  Created by Roy Hsu on 2021/6/17.
////
//
//import TinyUIKit
//import UIKit
//
//public final class UICollectionViewBridgeController<Coordinator>
//: UICollectionViewController {
//  private var environment: UIEnvironmentValues {
//    UIEnvironmentValues(traitCollection: traitCollection)
//  }
//  public var sections: [Section] {
//    didSet {
//      guard isViewLoaded else { return }
//      registerAllCells()
//    }
//  }
//  
//  public init(sections: [Section] = [], layout: UICollectionViewLayout) {
//    self.sections = sections
//    super.init(collectionViewLayout: layout)
//  }
//  
//  public required init?(coder: NSCoder) {
//    self.sections = []
//    super.init(coder: coder)
//  }
//  
//  // MARK: View Lifecycle
//  
//  public override func viewDidLoad() {
//    super.viewDidLoad()
//    registerAllCells()
//  }
//  
//  // MARK: UICollectionViewDataSource
//  
//  public override func numberOfSections(in collectionView: UICollectionView)
//  -> Int {
//    sections.count
//  }
//  
//  public override func collectionView(
//    _ collectionView: UICollectionView,
//    numberOfItemsInSection section: Int
//  ) -> Int {
//    sections[section].items.count
//  }
//  
//  public override func collectionView(
//    _ collectionView: UICollectionView,
//    cellForItemAt indexPath: IndexPath
//  ) -> UICollectionViewCell {
//    let item = sections[indexPath.section].items[AnyIndex(indexPath.row)]
//    let context = Item.Value.Context(
//      coordinator: .init(collectionView: collectionView, indexPath: indexPath),
//      environment: environment
//    )
//    let cell = item.value.makeUICell(context: context)
//    item.value.updateUICell(cell, context: context)
//    return cell
//  }
//  
//  // MARK: UICollectionViewDelegate
//  
//  public override func collectionView(
//    _ collectionView: UICollectionView,
//    didSelectItemAt indexPath: IndexPath
//  ) {
//    let item = sections[indexPath.section].items[AnyIndex(indexPath.row)]
//    item.onSelect()
//  }
//}
//
//extension UICollectionViewBridgeController {
//  private func registerAllCells() {
//    UICollectionViewCellRegistrationManager(collectionView: collectionView)
//      .registerAll(sections.flatMap(\.items).map(\.value))
//  }
//}
//
//// MARK: - Section
//
//extension UICollectionViewBridgeController {
//  public struct Section {
//    public var items: AnyCollection<Item>
//    
//    public init<C: Collection>(items: C)
//    where C.Element == Item, C.Index == Int {
//      self.items = AnyCollection(items)
//    }
//  }
//}
//
//// MARK: - Item
//
//extension UICollectionViewBridgeController {
//  public struct Item {
//    public var value: Value
//    public var onSelect: () -> Void = {}
//
//    public init<T: UIViewRepresentable>(
//      value: T,
//      onSelect: @escaping () -> Void = {}
//    ) where T.Coordinator == Coordinator {
//      self.value = Value(
//        value: AnyUIViewRepresentable(AnyUIViewRepresentable(value))
//      )
//      self.onSelect = onSelect
//    }
//    
//    public typealias Value = UICollectionViewItem<Element>
//  }
//}
//
//// MARK: - Element
//
//extension UICollectionViewBridgeController {
//  public typealias Element = AnyUIViewRepresentable<UIReusableView, Coordinator>
//}
