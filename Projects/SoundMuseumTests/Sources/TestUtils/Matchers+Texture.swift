//
//  Matchers+Texture.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/10/25.
//

import Nimble
import AsyncDisplayKit

/// 부모 노드에 추가한 자식 노드가 부모 노드에 추가되어 있는지를 검증할 때 사용합니다.
/// ex) expect(subnode).to(beADescendantOf(supernode))
func beADescendantOf(
  _ expectedAncestorNode: ASDisplayNode,
  sizeRange: ASSizeRange = ASSizeRangeZero
) -> Predicate<ASDisplayNode> {
  return Predicate.define { actualExpression in
    let message: ExpectationMessage
    let status: PredicateStatus

    let subnode = try actualExpression.evaluate()

    let layoutSpec: ASLayoutSpec
    if let layoutSpecBlock = expectedAncestorNode.layoutSpecBlock {
      layoutSpec = layoutSpecBlock(expectedAncestorNode, sizeRange)
    } else {
      layoutSpec = expectedAncestorNode.layoutSpecThatFits(sizeRange)
    }

    func traverse(_ layoutElements: [ASLayoutElement]?) -> ASLayoutElement? {
      guard let layoutElements = layoutElements else { return nil }
      for layoutElement in layoutElements {
        if layoutElement === subnode {
          return layoutElement
        } else if let layoutElements = (layoutElement as? ASLayoutSpec)?.children,
          let layoutElement = traverse(layoutElements) {
          return layoutElement
        }
      }
      return nil
    }
    let isDescendant = traverse(layoutSpec.children) != nil

    status = PredicateStatus(bool: isDescendant)
    message = .expectedTo(
      "be a descendant of \(String(describing: type(of: expectedAncestorNode)))"
    )

    return PredicateResult(status: status, message: message)
  }
}
