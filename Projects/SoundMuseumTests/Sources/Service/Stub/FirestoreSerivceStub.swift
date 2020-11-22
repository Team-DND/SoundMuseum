//
//  FirestoreSerivceStub.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/11/22.
//

import RxSwift
@testable import SoundMuseum

final class FirestoreSerivceStub: FirestoreSerivceProtocol {
  var fetchStub: () -> Observable<[Sound]>

  init(
    fetchStub: @escaping () -> Observable<[Sound]> = { .never() }
  ) {
    self.fetchStub = fetchStub
  }

  func fetchSound() -> Observable<[Sound]> {
    return self.fetchStub()
  }
}
