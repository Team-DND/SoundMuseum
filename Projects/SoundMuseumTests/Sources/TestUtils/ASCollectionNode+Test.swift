//
//  ASCollectionNode+Test.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/11/22.
//

import AsyncDisplayKit

extension Test where Base: ASCollectionNode {
  func numberOfSections() -> Int? {
    guard let dataSource = self.base.dataSource else { return nil }
    return dataSource.numberOfSections?(in: self.base)
  }

  func numberOfItems(at section: Int) -> Int? {
    guard let dataSource = self.base.dataSource else { return nil }
    return dataSource.collectionNode?(self.base, numberOfItemsInSection: section)
  }

  func node<C: ASCellNode>(_ type: C.Type, at indexPath: IndexPath) -> C? {
    guard let dataSource = self.base.dataSource else { return nil }
    if let nodeBlock = dataSource.collectionNode?(self.base, nodeBlockForItemAt: indexPath) {
      return nodeBlock() as? C
    } else {
      return dataSource.collectionNode?(self.base, nodeForItemAt: indexPath) as? C
    }
  }

  func node<C: ASCellNode>(_ type: C.Type, at section: Int, _ item: Int) -> C? {
    let indexPath = IndexPath(item: item, section: section)
    return self.node(type, at: indexPath)
  }

  func supplementaryNode<C: ASCellNode>(_ type: C.Type, supplementaryElementOfKind kind: String, at indexPath: IndexPath) -> C? {
    guard let dataSource = self.base.dataSource else { return nil }
    if let nodeBlock = dataSource.collectionNode?(self.base, nodeBlockForSupplementaryElementOfKind: kind, at: indexPath) {
      return nodeBlock() as? C
    } else {
      return dataSource.collectionNode?(self.base, nodeForSupplementaryElementOfKind: kind, at: indexPath) as? C
    }
  }
}
