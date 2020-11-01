//
//  TextNodeSpec.swift
//  DndUITests
//
//  Created by Gunter on 2020/11/01.
//

import Quick
import Nimble
import SoundMuseumTests

@testable import DndUI

final class TextNodeSpec: QuickSpec {
  override func spec() {
    it("생성 시 배경을 흰색, isOpaque 값을 true 로 갖습니다.") {
      let textNode = TextNode()
      expect(textNode.backgroundColor) == .white
      expect(textNode.isOpaque) == true
    }

    it("투명한 배경색을 지정하면 isOpaque 값이 false 로 변경됩니다.") {
      // given
      let textNode = TextNode()

      // when
      textNode.backgroundColor = UIColor(red: 0.5, green: 0.1, blue: 0.2, alpha: 0.3)

      // then
      expect(textNode.isOpaque) == false
    }

    it("불투명한 배경색을 지정하면 isOpaque 값이 true 로 변경됩니다.") {
      // given
      let textNode = TextNode()

      // when
      textNode.backgroundColor = .black

      // then
      expect(textNode.isOpaque) == true
    }
  }
}

