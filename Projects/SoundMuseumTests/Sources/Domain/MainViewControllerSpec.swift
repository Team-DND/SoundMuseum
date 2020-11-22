//
//  MainViewControllerSpec.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/10/25.
//

import AsyncDisplayKit
import ReactorKit
import DndUI
import Nimble
import Quick

@testable import SoundMuseum

final class MainViewControllerSpec: QuickSpec {
  override func spec() {
    var reactor: MainViewReactor!

    beforeEach {
      reactor = MainViewReactor.Factory.dummy().create(payload: .init())
      reactor.isStubEnabled = true
    }

    func createViewController() -> MainViewController {
      let factory = MainViewController.Factory.init(dependency: .init())
      let viewController = factory.create(payload: .init(reactor: reactor))
      return viewController
    }

    it("콜렉션 노드를 표시합니다") {
      // given
      let viewController = createViewController()

      // then
      expect(viewController.testables[\.collectionNode]).to(beADescendantOf(viewController.node))
    }

    context("뷰가 로드되었을 때") {
      it("initialize 액션을 전송합니다.") {
        let viewController = createViewController()
        viewController.viewDidLoad()
        expect(reactor.stub.actions.last).to(match) {
          guard case .initialize = $0 else { return false }
          return true
        }
      }
    }

    context("collectionNode") {
      it("사운드 셀을 표시할 수 있습니다.") {
        // given
        let viewController = createViewController()

        // when
        reactor.stub.state.value.sections = [
          SoundListViewSection(identity: .sounds, items: [.sounds(Sound(name: "gunter", soundURL: "", imgURL: ""))]),
        ]

        // then
        let cellNode = viewController.testables[\.collectionNode].test.node(ASCellNode.self, at: 0, 0)
        expect(cellNode?.subnodes?.first).to(beAKindOf(ImageMediumCell.self))
      }
    }
  }
}
