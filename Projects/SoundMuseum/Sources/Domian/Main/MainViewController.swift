//
//  ViewController.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/10/25.
//

import AsyncDisplayKit
import ReactorKit
import RxViewController
import BonMot
import DndUI
import Then
import Pure

class MainViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
  }

  struct Payload {
    let reactor: MainViewReactor
  }


  // MARK: Constants

  private enum Metric {
    static let itemSpacing = 15.f
    static let padding = 12.f
  }


  // MARK: Properties

  private let dependency: Dependency
  private let payload: Payload
  private lazy var dataSource = self.createDataSource()

  // MARK: UI

  private let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
  }


  // MARK: Initializing

  required init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    self.dependency = dependency
    self.payload = payload
    super.init()
    self.node.backgroundColor = .white
  }

  private func createDataSource() -> CollectionNodeDataSource<SoundListViewSection> {
    let dataSource = CollectionNodeDataSource<SoundListViewSection>(
      configureCellBlock: { [weak self] dataSource, collectionNode, indexPath, sectionItem in
        let sectionWidth = collectionNode.constrainedSizeForCalculatedLayout.max.width
        switch sectionItem {
        case let .sounds(sound):
          return {
            let width = floor((sectionWidth - Metric.itemSpacing) / 2)
            let node = ImageMediumCell {
            }
            node.titleTextAlignment = .center
            node.titleText = sound.name
            log.debug(sound.imgURL)
            node.imageUrl = URL(string: sound.imgURL)
            node.titleTextColor = .gray100
            return ASCellNode(wrapping: node).styled {
              $0.preferredLayoutSize.width = ASDimension(unit: .points, value: width)
            }
          }
        case .activityIndicator:
          return { ASCellNode() }
        }
      })
    return dataSource
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.node.backgroundColor = .gray900
    self.navigationController?.navigationBar.isHidden = true
    self.collectionNode.delegate = self
  }


  // MARK: Binding

  func bind(reactor: MainViewReactor) {
    self.rx.viewDidLoad
      .map { Reactor.Action.initialize }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.collectionNode.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
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

#if DEBUG
import Testables

extension MainViewController: Testable {
  final class TestableKeys: TestableKey<Self> {
    let collectionNode = \Self.collectionNode
  }
}
#endif
