//
//  ContactListController.swift
//  Demo
//
//  Created by Roy Hsu on 2021/7/10.
//

import TinyUIKit
import UIKit

final class ContactListController: UIViewController {
//  private let contentViewController = UITableViewBridgeController<Void>()
  private let listLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionHeadersPinToVisibleBounds = true
    return layout
  }()
  private typealias Section = UICollectionViewBridgingController.Section
  private typealias Item = UICollectionViewBridgingController.Item
  private lazy var contentViewController =
    UICollectionViewBridgingController(collectionViewLayout: listLayout)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentViewController.collectionView.layoutMargins = .zero
    contentViewController.sections = [
      Section(
        header: UICollectionViewSupplementary(content: UIContactListHeader())
          .onWillAppear { _, _ in print("Header appeared.") },
        items: [
          Item(
            content: UIContactRow(),
            sizeProvider: .verticallyScrollingGridLayout(columnCount: 3)
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .verticallyScrollingGridLayout(columnCount: 3)
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .verticallyScrollingGridLayout(columnCount: 3)
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: { _, _ in CGSize(width: 200.0, height: 200.0) }
          ),
          Item(
            content: UIContactRow()
          )
          .onSelect { _, _ in
            print("Selected!!")
          },
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
          Item(
            content: UIContactRow(),
            sizeProvider: .listLayout
          ),
        ],
        footer: UICollectionViewSupplementary(content: UIContactListHeader())
          .onWillAppear { _, _ in print("Footer appeared.") }
      )
    ]
    contentViewController.collectionView.backgroundColor = .white
    contentViewController.collectionView.reloadData()
    
    addChild(contentViewController)
    
    let contentView = contentViewController.view!
    
    // Layout.
    contentView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(contentView)
    NSLayoutConstraint.activate([
        // Horizontal.
        contentView.leadingAnchor
          .constraint(equalTo: view.leadingAnchor),
        contentView.trailingAnchor
          .constraint(equalTo: view.trailingAnchor),
        
        // Vertical.
        contentView.topAnchor
          .constraint(equalTo: view.topAnchor),
        contentView.bottomAnchor
          .constraint(equalTo: view.bottomAnchor),
        
//      // Horizontal.
//      contentView.leadingAnchor
//        .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//      contentView.trailingAnchor
//        .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//
//      // Vertical.
//      contentView.topAnchor
//        .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//      contentView.bottomAnchor
//        .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    contentViewController.didMove(toParent: self)
  }
  
  override func viewWillTransition(
    to size: CGSize,
    with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate { context in
      self.contentViewController.collectionViewLayout.invalidateLayout()
    } completion: { context in }
  }
}

struct UIContactRow: UIViewRepresentable {
  func makeUIView(context: Context) -> UILabel {
    UILabel()
  }
  
  func updateUIView(_ label: UILabel, context: Context) {
    label.text = "Katherine\nKatherine\nKatherine\nKatherine"
    label.numberOfLines = 0
    label.backgroundColor = .red
  }
  
  typealias Coordinator = Void
}

struct UIContactNameTextField: UIViewRepresentable {
  func makeUIView(context: Context) -> UITextField {
    UITextField()
  }
  
  func updateUIView(_ textField: UITextField, context: Context) {
    textField.borderStyle = .roundedRect
  }
  
  typealias Coordinator = Void
}

struct UIContactListHeader: UIViewRepresentable {
  func makeUIView(context: Context) -> UILabel {
    UILabel()
  }
  
  func updateUIView(_ label: UILabel, context: Context) {
    label.text = "Header\nHeader\nHeader"
    label.numberOfLines = 0
    label.backgroundColor = .yellow
  }
  
  typealias Coordinator = Void
}

extension UICollectionViewFlowLayout {
  public var contentRect: CGRect {
    guard let collectionView = collectionView else { return .zero }
    return collectionView.frame.inset(by: sectionInset)
  }
  
  /// The item width that can fit within the given `columnCount`.
  public func itemWidthForVerticallyScrollingGridLayout(columnCount: Int)
  -> CGFloat {
    precondition(columnCount > 0)
    let interitemSpacerCount = columnCount - 1
    let totalSpacingForInteritems = minimumInteritemSpacing
      * CGFloat(interitemSpacerCount)
    let width = (contentRect.width - totalSpacingForInteritems)
      / CGFloat(columnCount)
    // Rounded for pixel-perfect.
    // We must use rounded down value to prevent exceeding `columnCount`.
    return width.rounded(.down)
  }
  
//  public func cellSizeForListLayout(for cell: UICollectionViewCell) -> CGSize {
//    let size = cell.systemLayoutSizeFitting(
//      contentRect.size,
//      withHorizontalFittingPriority: .required,
//      verticalFittingPriority: .fittingSizeLevel
//    )
//    return CGSize(width: containerRect.width, height: size.height)
//  }
}

//private static func fullWidthForItem(
//  cell: UICollectionViewCell,
//  context: Item.Context
//) -> CGSize? {
//  guard let layout = context.collectionView
//          .collectionViewLayout as? UICollectionViewFlowLayout
//  else { return nil }
//  let containerRect = layout.containerRect
//  let size = cell.systemLayoutSizeFitting(
//    containerRect.size,
//    withHorizontalFittingPriority: .required,
//    verticalFittingPriority: .fittingSizeLevel
//  )
//  return CGSize(width: containerRect.width, height: size.height)
//}

//final class ListLayout: UICollectionViewFlowLayout {
//  static let elementKindSectionBackground = "ListLayout.Background"
//
//  private struct SectionBackgroundDecoration {
//    var layoutAttributes: UICollectionViewLayoutAttributes
//  }
//
//  private typealias SectionIndex = Int
//  private var sectionBackgroundDecorationInfo
//    : [SectionIndex: SectionBackgroundDecoration] = [:]
//
//  override func prepare() {
//    super.prepare()
//    #warning("TODO: [Priority: high] potential performance bottle neck when scrolling. (layout)")
//    sectionBackgroundDecorationInfo = [:]
//    guard let collectionView = collectionView else { return }
//    let numberOfSections = collectionView.numberOfSections
//    for sectionIndex in 0..<numberOfSections {
//      let numberOfItems = collectionView.numberOfItems(inSection: sectionIndex)
//      let firstIndexPathInSection = IndexPath(item: 0, section: sectionIndex)
//      guard let firstItemAttributes
//              = layoutAttributesForItem(at: firstIndexPathInSection)
//      else { continue }
//      let newDecoration = SectionBackgroundDecoration(
//        layoutAttributes: UICollectionViewLayoutAttributes(
//          forDecorationViewOfKind: Self.elementKindSectionBackground,
//          with: firstIndexPathInSection
//        )
//      )
//      print("numberOfItems", numberOfItems)
//      print("Screen.bound", UIScreen.main.bounds)
//      let lastItemIndex = numberOfItems - 1
//      let lastItemIndexPath
//        = IndexPath(item: lastItemIndex, section: sectionIndex)
//      if lastItemIndex > 1,
//         let lastItemAttributes
//           = layoutAttributesForItem(at: lastItemIndexPath) {
//        print("firstItemAttributes", firstItemAttributes)
//        print("lastItemAttributes", lastItemAttributes)
//        let containerRect
//          = collectionView.bounds.inset(by: collectionView.layoutMargins)
//        newDecoration.layoutAttributes.zIndex = -1
//        newDecoration.layoutAttributes.frame = CGRect(
//          x: containerRect.minX,
//          y: firstItemAttributes.frame.minY,
//          width: containerRect.width,
//          height: lastItemAttributes.frame.maxY - firstItemAttributes.frame.minY
//        )
//      } else {
//        newDecoration.layoutAttributes.bounds = .zero
//      }
//      sectionBackgroundDecorationInfo[sectionIndex] = newDecoration
//    }
//    register(
//      BlueView.self,
//      forDecorationViewOfKind: Self.elementKindSectionBackground
//    )
//  }
//
//  override func layoutAttributesForElements(in rect: CGRect)
//  -> [UICollectionViewLayoutAttributes]? {
//    var currentAttributes = super.layoutAttributesForElements(in: rect)
//    let attributesForVisibleBackgroundDecorations
//      = sectionBackgroundDecorationInfo.compactMap {
//        (sectionIndex, decoration) in
//        decoration.layoutAttributes.frame.intersects(rect)
//          ? decoration.layoutAttributes
//          : nil
//      }
//    currentAttributes?
//      .append(contentsOf: attributesForVisibleBackgroundDecorations)
//    return currentAttributes
//  }
//
//  override func layoutAttributesForDecorationView(
//    ofKind elementKind: String,
//    at indexPath: IndexPath
//  ) -> UICollectionViewLayoutAttributes? {
//    sectionBackgroundDecorationInfo[indexPath.section]?.layoutAttributes
//  }
//
//  override func layoutAttributesForSupplementaryView(
//    ofKind elementKind: String,
//    at indexPath: IndexPath
//  ) -> UICollectionViewLayoutAttributes? {
//    super.layoutAttributesForSupplementaryView(
//      ofKind: elementKind,
//      at: indexPath
//    )
//  }
//}

public final class BlueView: UICollectionReusableView {
  private lazy var widthConstraint
    = widthAnchor.constraint(equalToConstant: preferredMaxLayoutWidth)
  
  var preferredMaxLayoutWidth: CGFloat = 44.0 {
    didSet {
      widthConstraint.constant = preferredMaxLayoutWidth
      setNeedsLayout()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .blue
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      widthConstraint,
      heightAnchor.constraint(equalToConstant: 50.0),
    ])
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    backgroundColor = .blue
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      widthConstraint,
      heightAnchor.constraint(equalToConstant: 50.0),
    ])
  }
}
