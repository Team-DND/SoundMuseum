//
//  ActivityIndicatorCellNode.swift
//  DndUI
//
//  Created by Gunter on 2020/11/28.
//

import AsyncDisplayKit

final public class ActivityIndicatorCellNode: ASCellNode {
  private let activityIndicatorNode = ActivityIndicatorNode(style: .medium).then {
    $0.style.preferredSize = CGSize(width: 20, height: 20)
  }

  override public init() {
    super.init()
    self.style.preferredLayoutSize.width = 100%
    self.style.preferredLayoutSize.height = 44
    self.automaticallyManagesSubnodes = true
  }

  override public func didEnterVisibleState() {
    super.didEnterVisibleState()
    self.activityIndicatorNode.startAnimating()
  }

  override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASCenterLayoutSpec(
      centeringOptions: .XY,
      sizingOptions: .minimumXY,
      child: self.activityIndicatorNode
    )
  }
}
