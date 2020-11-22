//
//  Array+SectionModel.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import RxDataSources

extension Array where Element: SectionModelType {
  subscript(indexPath: IndexPath) -> Element.Item {
    get {
      return self[indexPath.section].items[indexPath.item]
    }
    mutating set {
      self.update(section: indexPath.section) { items in
        items[indexPath.item] = newValue
      }
    }
  }

  mutating func insert(newElement: Element.Item, at indexPath: IndexPath) {
    self.update(section: indexPath.section) { items in
      items.insert(newElement, at: indexPath.item)
    }
  }

  @discardableResult
  mutating func remove(at indexPath: IndexPath) -> Element.Item {
    return self.update(section: indexPath.section) { items in
      return items.remove(at: indexPath.item)
    }
  }

  mutating func replace(section: Int, items: [Element.Item]) {
    self[section] = Element.init(original: self[section], items: items)
  }

  private mutating func update<T>(section: Int, mutate: (inout [Element.Item]) -> T) -> T {
    var items = self[section].items
    let value = mutate(&items)
    self[section] = Element.init(original: self[section], items: items)
    return value
  }

  func withSectionItems() -> [(Element, Element.Item)] {
    return self.flatMap { section in
      section.items.map { sectionItem in (section, sectionItem) }
    }
  }
}

extension Array where Element: SectionModelType, Element.Item: Hashable {
  private typealias Section = Element

  func removingDuplicates() -> [Element] {
    var set = Set<Section.Item>()
    return self.compactMap { section -> Section? in
      let uniqueItems = section.items.filter { set.insert($0).inserted }
      guard !uniqueItems.isEmpty else { return nil }
      return Section(original: section, items: uniqueItems)
    }
  }

  mutating func removeDuplicates() {
    self = self.removingDuplicates()
  }
}
