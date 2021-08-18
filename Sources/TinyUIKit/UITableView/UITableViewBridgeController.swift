//
//  UITableViewBridgeController.swift
//
//
//  Created by Roy Hsu on 2021/6/16.
//

import UIKit

open class UITableViewBridgeController<Coordinator>: UITableViewController {
  
  // MARK: Data Source
  
  public var sections: [Section] = []
  
  public override init(style: UITableView.Style = .plain) {
    super.init(style: style)
    self.setUp()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.setUp()
  }
  
  // MARK: View Lifecycle

  private func setUp() {
    tableView.separatorStyle = .none
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
    guard indexPath.section < sections.count else {
      return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    let section = sections[indexPath.section]
    guard indexPath.row < section.items.count else {
      return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
    let item = section.items[AnyIndex(indexPath.row)]
    let context = Item.Context(
      coordinator: Item.Coordinator(tableView: tableView, indexPath: indexPath),
      environment: environment
    )
    let cell = item.makeUITableViewCell(context: context)
    cell.selectionStyle = .none
    item.updateUITableViewCell(cell, context: context)
    return cell
  }

  // MARK: UITableViewDelegate
  
  public override func tableView(
    _ tableView: UITableView,
    willDisplayHeaderView view: UIView,
    forSection section: Int
  ) {
    guard section < sections.count else { return }
    let section = sections[section]
    section.header?.onWillAppear?(view)
  }

  public override func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    guard indexPath.section < sections.count else { return }
    let section = sections[indexPath.section]
    guard indexPath.row < section.items.count else { return }
    let item = section.items[AnyIndex(indexPath.row)]
    item.onWillAppear?()
  }

  public override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    guard indexPath.section < sections.count else { return }
    let section = sections[indexPath.section]
    guard indexPath.row < section.items.count else { return }
    let item = section.items[AnyIndex(indexPath.row)]
    item.onSelect?()
  }

  public override func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    guard section < sections.count else { return 0.0 }
    let section = sections[section]
    return (section.header == nil) ? 0.0 : UITableView.automaticDimension
  }

  public override func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard section < sections.count else { return nil }
    let section = sections[section]
    guard let header = section.header else { return nil }
    let context = Supplementary.Context(
      coordinator: Supplementary.Coordinator(tableView: tableView),
      environment: environment
    )
    let view = header.makeUITableViewSupplementaryView(context: context)
    header.updateUITableViewSupplementaryView(view, context: context)
    return view
  }

  public override func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    guard section < sections.count else { return 0.0 }
    let section = sections[section]
    return (section.footer == nil) ? 0.0 : UITableView.automaticDimension
  }

  public override func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    guard section < sections.count else { return nil }
    let section = sections[section]
    guard let footer = section.footer else { return nil }
    let context = Supplementary.Context(
      coordinator: Supplementary.Coordinator(tableView: tableView),
      environment: environment
    )
    let view = footer.makeUITableViewSupplementaryView(context: context)
    footer.updateUITableViewSupplementaryView(view, context: context)
    return view
  }
}

// MARK: - Helpers

extension UITableViewBridgeController {
  public typealias Item = UITableViewRow
  public typealias Supplementary = UITableViewSupplementary
  
  public struct Section {
    public var id: String
    public var header: Supplementary?
    public var items: AnyCollection<Item>
    public var footer: Supplementary?
    
    public init<C: Collection>(
      id: String? = nil,
      header: Supplementary? = nil,
      items: C,
      footer: Supplementary? = nil
    ) where C.Element == Item, C.Index == Int {
      self.id = id ?? UUID().uuidString
      self.header = header
      self.items = AnyCollection(items)
      self.footer = footer
    }
  }
  
  private var environment: UIEnvironmentValues {
    UIEnvironmentValues(traitCollection: traitCollection)
  }
}
