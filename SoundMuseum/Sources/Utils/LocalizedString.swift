//
//  LocalizedString.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/10/25.
//

import Foundation

public func __(_ key: String) -> String {
  return NSLocalizedString(key, comment: "")
}
