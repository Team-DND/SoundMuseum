//
//  DummyError.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/10/25.
//

public struct DummyError: Error, Equatable {
  public let identifier: String?

  public init(identifier: String? = nil) {
    self.identifier = identifier
  }
}

