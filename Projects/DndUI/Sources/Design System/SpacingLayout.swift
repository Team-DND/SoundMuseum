//
//  SpacingLayout.swift
//  DndUI
//
//  Created by Gunter on 2020/11/01.
//

import AsyncDisplayKit

public final class SpacingLayout: ASLayoutSpec {
  public init(width: CGFloat = 0, height: CGFloat = 0) {
    super.init()
    self.style.preferredSize.width = width
    self.style.preferredSize.height = height
  }
}

