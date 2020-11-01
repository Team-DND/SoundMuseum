//
//  ASCellNode.swift
//  DndUI
//
//  Created by Gunter on 2020/11/01.
//

import AsyncDisplayKit

extension ASCellNode {
  public convenience init(
    wrapping: ASDisplayNode,
    layoutSpecBuilder: ((ASDisplayNode, ASCellNode, ASSizeRange) -> ASLayoutSpec)? = nil
  ) {
    self.init()
    self.addSubnode(wrapping)
    self.layoutSpecBlock = { (cell, constrainedSize) -> ASLayoutSpec in
      guard let cell = cell as? ASCellNode else { return ASLayoutSpec() }
      guard let layoutSpecBuilder = layoutSpecBuilder else { return ASWrapperLayoutSpec(layoutElement: wrapping) }
      return layoutSpecBuilder(wrapping, cell, constrainedSize)
    }
  }
}
