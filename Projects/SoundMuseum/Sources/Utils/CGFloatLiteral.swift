//
//  CGFloatLiteral.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/01.
//

import UIKit

public extension IntegerLiteralType {
  var f: CGFloat { return CGFloat(self) }
}

public extension UnsignedInteger {
  var f: CGFloat { return CGFloat(self) }
}

public extension FloatLiteralType {
  var f: CGFloat { return CGFloat(self) }
}
