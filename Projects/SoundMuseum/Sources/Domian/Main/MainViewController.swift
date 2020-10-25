//
//  ViewController.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/10/25.
//

import AsyncDisplayKit
import BonMot
import DndUI
import Then

class MainViewController: BaseViewController {

  // MARK: Properties


  // MARK: Initializing

  override init() {
    super.init()
    self.node.backgroundColor = .white
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.node.backgroundColor = .gray900
    self.navigationController?.navigationBar.isHidden = true
  }


  // MARK: UI

  private let textNode = ASTextNode().then {
    $0.attributedText = __("Hello World").styled(with: Typo.h1Font(color: .gray100))
  }

  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASCenterLayoutSpec(
      centeringOptions: .XY,
      sizingOptions: .minimumXY,
      child: textNode
    )
  }
}

import Testables

extension MainViewController: Testable {
  final class TestableKeys: TestableKey<Self> {
    let textNode = \Self.textNode
  }
}
