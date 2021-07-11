//
//  UICollectionViewBridgeCell.swift
//
//
//  Created by Roy Hsu on 2021/6/13.
//

import UIKit

public final class UICollectionViewBridgeCell<UIViewType: UIView>
: UICollectionViewCell {
  private(set) var bridgeView: UIViewType?
  private var bridgeViewWidthConstraint: NSLayoutConstraint?
  private var bridgeViewHeightConstraint: NSLayoutConstraint?
  private var layoutInfoProvider: LayoutInfoProvider?
  
  public typealias LayoutInfoProvider = () -> (
    containerSize: CGSize,
    itemSize: UICollectionViewLayoutSize
  )
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    let reusableView = bridgeView as? Reusable
    reusableView?.prepareForReuse()
  }
  
  public override func preferredLayoutAttributesFitting(
    _ layoutAttributes: UICollectionViewLayoutAttributes
  ) -> UICollectionViewLayoutAttributes {
    let newAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
    NSLayoutConstraint.deactivate(
      [
        bridgeViewWidthConstraint,
        bridgeViewHeightConstraint,
      ]
      .compactMap { $0 }
    )
    guard let (containerSize, itemSize) = layoutInfoProvider?() else {
      return newAttributes
    }
    let width: CGFloat
    let height: CGFloat
    defer {
      newAttributes.bounds.size.width = width
      newAttributes.bounds.size.height = height
    }
    switch (itemSize.widthDimension, itemSize.heightDimension) {
    case (.absolute, .absolute):
      width = itemSize.width
      height = itemSize.height
    case (.absolute, .estimated):
      if let bridgeViewWidthConstraint = bridgeViewWidthConstraint {
        bridgeViewWidthConstraint.constant = itemSize.width
        NSLayoutConstraint.activate([bridgeViewWidthConstraint])
      }
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.height
    case (.absolute, .fractionalWidth):
      width = itemSize.width
      height = containerSize.width * itemSize.width
    case (.absolute, .fractionalHeight):
      width = itemSize.width
      height = containerSize.height * itemSize.height
    case (.estimated, .absolute):
      if let bridgeViewHeightConstraint = bridgeViewHeightConstraint {
        bridgeViewHeightConstraint.constant = itemSize.height
        NSLayoutConstraint.activate([bridgeViewHeightConstraint])
      }
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.height
    case (.estimated, .estimated):
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.height
    case (.estimated, .fractionalWidth):
      if let bridgeViewHeightConstraint = bridgeViewHeightConstraint {
        bridgeViewHeightConstraint.constant
          = containerSize.width * itemSize.width
        NSLayoutConstraint.activate([bridgeViewHeightConstraint])
      }
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.width
    case (.estimated, .fractionalHeight):
      if let bridgeViewHeightConstraint = bridgeViewHeightConstraint {
        bridgeViewHeightConstraint.constant
          = containerSize.height * itemSize.height
        NSLayoutConstraint.activate([bridgeViewHeightConstraint])
      }
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.height
    case (.fractionalWidth, .absolute):
      width = containerSize.width * itemSize.width
      height = itemSize.height
    case (.fractionalWidth, .estimated):
      if let bridgeViewWidthConstraint = bridgeViewWidthConstraint {
        bridgeViewWidthConstraint.constant
          = containerSize.width * itemSize.width
        NSLayoutConstraint.activate([bridgeViewWidthConstraint])
      }
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.height
    case (.fractionalWidth, .fractionalWidth):
      width = containerSize.width * itemSize.width
      height = containerSize.width * itemSize.width
    case (.fractionalWidth, .fractionalHeight):
      width = containerSize.width * itemSize.width
      height = containerSize.height * itemSize.height
    case (.fractionalHeight, .absolute):
      width = containerSize.height * itemSize.height
      height = itemSize.height
    case (.fractionalHeight, .estimated):
      if let bridgeViewWidthConstraint = bridgeViewWidthConstraint {
        bridgeViewWidthConstraint.constant
          = containerSize.height * itemSize.height
        NSLayoutConstraint.activate([bridgeViewWidthConstraint])
      }
      let estimatedSize
        = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      width = estimatedSize.width
      height = estimatedSize.height
    case (.fractionalHeight, .fractionalWidth):
      width = containerSize.height * itemSize.height
      height = containerSize.width * itemSize.width
    case (.fractionalHeight, .fractionalHeight):
      width = containerSize.height * itemSize.height
      height = containerSize.height * itemSize.height
    }
    return newAttributes
  }
}

// MARK: - Helpers

public extension UICollectionViewBridgeCell {
  func updateUI<Value: UIViewRepresentable>(
    with value: Value,
    layoutInfoProvider: LayoutInfoProvider?,
    context: Value.Context
  ) where Value.UIViewType == UIViewType {
    self.layoutInfoProvider = layoutInfoProvider
    NSLayoutConstraint.deactivate(
      [
        bridgeViewWidthConstraint,
        bridgeViewHeightConstraint,
      ]
      .compactMap { $0 }
    )
    if let bridgeView = bridgeView , bridgeView.superview === contentView {
      bridgeViewWidthConstraint
        = bridgeView.widthAnchor.constraint(equalToConstant: 44.0)
      bridgeViewHeightConstraint
        = bridgeView.heightAnchor.constraint(equalToConstant: 44.0)
      value.updateUIView(bridgeView, context: context)
    } else {
      let newView = value.makeUIView(context: context)
      bridgeViewWidthConstraint
        = newView.widthAnchor.constraint(equalToConstant: 44.0)
      bridgeViewHeightConstraint
        = newView.heightAnchor.constraint(equalToConstant: 44.0)
      
      value.updateUIView(newView, context: context)
      bridgeView = newView

      // Layout.
      newView.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(newView)
      NSLayoutConstraint.activate([
        // Horizontal.
        newView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        newView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

        // Vertical.
        newView.topAnchor.constraint(equalTo: contentView.topAnchor),
        newView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      ])
    }
  }
}
