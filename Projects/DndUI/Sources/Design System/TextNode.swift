//
//  TextNode.swift
//  DndUI
//
//  Created by Gunter on 2020/11/01.
//

import AsyncDisplayKit

public final class TextNode: ASTextNode {
  public override init() {
    super.init()
    self.isLayerBacked = true
    self.backgroundColor = .white
    self.isOpaque = true
  }

  public override var backgroundColor: UIColor? {
    didSet {
      var alpha: CGFloat = 0.0
      self.backgroundColor?.getRed(nil, green: nil, blue: nil, alpha: &alpha)
      self.isOpaque = (alpha >= 1)
    }
  }
}

