//
//  ASDimension.swift
//  DndUI
//
//  Created by Gunter on 2020/11/25.
//

import AsyncDisplayKit

public extension ASDimension {
  static var auto: ASDimension {
    return ASDimensionAuto
  }

  static func points(_ value: CGFloat) -> ASDimension {
    return ASDimension(unit: .points, value: value)
  }

  static func fraction(_ value: CGFloat) -> ASDimension {
    return ASDimension(unit: .fraction, value: value)
  }
}

extension ASDimension: ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = Int

  public init(integerLiteral value: Int) {
    self = ASDimension(unit: .points, value: CGFloat(value))
  }
}

extension ASDimension: ExpressibleByFloatLiteral {
  public typealias FloatLiteralType = Double

  public init(floatLiteral value: FloatLiteralType) {
    self = ASDimension(unit: .points, value: CGFloat(value))
  }
}

postfix operator %
public postfix func % (value: CGFloat) -> ASDimension {
  return ASDimension(unit: .fraction, value: value / 100)
}

