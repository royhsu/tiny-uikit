//
//  UITableViewBridgeController.swift
//
//
//  Created by Roy Hsu on 2021/6/16.
//

import TinyUIKit
import UIKit

public final class UITableViewBridgeController<Coordinator>
: UITableViewController {
  private var environment: UIEnvironmentValues {
    UIEnvironmentValues(traitCollection: traitCollection)
  }
  public var sections: [Section] {
    didSet {
      guard isViewLoaded else { return }
      registerAllCells()
    }
  }

  public init(sections: [Section] = []) {
    self.sections = sections
    super.init(style: .plain)
  }

  public required init?(coder: NSCoder) {
    self.sections = []
    super.init(coder: coder)
  }

  // MARK: View Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.separatorStyle = .none
    registerAllCells()
  }

  // MARK: UITableViewDataSource

  public override func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }

  public override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    sections[section].items.count
  }

  public override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let item = sections[indexPath.section].items[AnyIndex(indexPath.row)]
    let context = Item.Content.Context(
      coordinator: .init(tableView: tableView, indexPath: indexPath),
      environment: environment
    )
    let cell = item.content.makeUITableViewCell(context: context)
    cell.selectionStyle = .none
    item.content.updateUITableViewCell(cell, context: context)
    return cell
  }

  // MARK: UITableViewDelegate

  public override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    let item = sections[indexPath.section].items[AnyIndex(indexPath.row)]
    item.onSelect()
  }

  public override func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    let header = sections[section].header
    return header == nil ? 0.0 : UITableView.automaticDimension
  }

  public override func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let header = sections[section].header else { return nil }
    let context = Supplementary.Content.Context(
      coordinator: Supplementary.Content.Coordinator(tableView: tableView),
      environment: environment
    )
    let view = header.content.makeUITableViewSupplementaryView(context: context)
    header.content.updateUITableViewSupplementaryView(view, context: context)
    return view
  }

  public override func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    let footer = sections[section].footer
    return footer == nil ? 0.0 : UITableView.automaticDimension
  }

  public override func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    guard let footer = sections[section].footer else { return nil }
    let context = Supplementary.Content.Context(
      coordinator: .init(tableView: tableView),
      environment: environment
    )
    let view = footer.content.makeUITableViewSupplementaryView(context: context)
    footer.content.updateUITableViewSupplementaryView(view, context: context)
    return view
  }
}

extension UITableViewBridgeController {
  private func registerAllCells() {
    UITableViewCellRegistrationManager(tableView: tableView)
      .registerAll(sections.flatMap(\.items).map(\.content))
  }
}

// MARK: - Section

extension UITableViewBridgeController {
  public struct Section {
    public var header: Supplementary?
    public var items: AnyCollection<Item>
    public var footer: Supplementary?
    #warning("TODO: [Priority: high] header/footer registration. (my learning)")
    public init<C: Collection>(
      header: Supplementary? = nil,
      items: C,
      footer: Supplementary? = nil
    ) where C.Element == Item, C.Index == Int {
      self.header = header
      self.items = AnyCollection(items)
      self.footer = footer
    }
  }
}

// MARK: - Item

extension UITableViewBridgeController {
  public struct Item {
    public var content: Content
    public var onSelect: () -> Void

    public init<T: UIViewRepresentable>(
      content: T,
      onSelect: @escaping () -> Void = {}
    ) where T.UIViewType: Reusable, T.Coordinator == Coordinator {
      self.content = Content(
        reuseIdentifier: content.reuseIdentifier,
        value: AnyTypeErasedUIViewRepresentable(content)
      )
      self.onSelect = onSelect
    }

    public typealias Content = UITableViewRow<UIView>
  }
}

// MARK: - Supplementary

extension UITableViewBridgeController {
  public struct Supplementary {
    public var content: Content

    public init<T: UIViewRepresentable>(
      content: T,
      onSelect: @escaping () -> Void = {}
    ) where T.UIViewType: Reusable, T.Coordinator == Coordinator {
      self.content = Content(
        reuseIdentifier: content.reuseIdentifier,
        value: AnyTypeErasedUIViewRepresentable(content)
      )
    }

    public typealias Content = UITableViewSupplementary<UIView>
  }
}
