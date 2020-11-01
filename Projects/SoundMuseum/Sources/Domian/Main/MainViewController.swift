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

  // MARK: Constants

  private enum Metric {
    static let itemSpacing = 15.f
    static let padding = 12.f
  }


  // MARK: Properties


  // MARK: UI

  private let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
  }


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
    self.collectionNode.dataSource = self
    self.collectionNode.delegate = self
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(
      insets: UIEdgeInsets(top: 40, left: Metric.padding, bottom: 0, right: Metric.padding),
      child: self.collectionNode
    )
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, ASCollectionDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }
}

extension MainViewController: ASCollectionDataSource {
  func collectionNode(
    _ collectionNode: ASCollectionNode,
    numberOfItemsInSection section: Int
  ) -> Int {
    return 40
  }

  func collectionNode(
    _ collectionNode: ASCollectionNode,
    nodeBlockForItemAt indexPath: IndexPath
  ) -> ASCellNodeBlock {
    let sectionWidth = collectionNode.constrainedSizeForCalculatedLayout.max.width
    return {
      let width = floor((sectionWidth - Metric.itemSpacing) / 2)
      let node = ImageMediumCell()
      node.titleTextAlignment = .center
      node.titleText = "Test"
      node.titleTextColor = .gray100
      return ASCellNode(wrapping: node).styled {
        $0.preferredLayoutSize.width = ASDimension(unit: .points, value: width)
      }
    }
  }
}

import Testables

extension MainViewController: Testable {
  final class TestableKeys: TestableKey<Self> {
    let collectionNode = \Self.collectionNode
  }
}
