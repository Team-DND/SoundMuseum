//
//  TestExtension.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import Foundation

final class Test<Base> {
  let base: Base

  init(base: Base) {
    self.base = base
  }
}

protocol TestExtension {
  associatedtype Base

  static var test: Test<Base>.Type { get }
  var test: Test<Base> { get }
}

extension TestExtension {
  static var test: Test<Self>.Type {
    return Test.self
  }

  var test: Test<Self> {
    return Test(base: self)
  }
}

extension NSObject: TestExtension {
}
