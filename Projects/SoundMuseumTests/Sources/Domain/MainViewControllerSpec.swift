//
//  MainViewControllerSpec.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/10/25.
//

import Nimble
import Quick

@testable import SoundMuseum

final class MainViewControllerSpec: QuickSpec {
  override func spec() {
    func createViewController() -> MainViewController {
      let viewController = MainViewController()
      viewController.loadViewIfNeeded()
      return viewController
    }

    it("콜렉션 노트를 표시합니다") {
      // given
      let viewController = createViewController()

      // then
      expect(viewController.testables[\.collectionNode]).to(beADescendantOf(viewController.node))
    }
  }
}
