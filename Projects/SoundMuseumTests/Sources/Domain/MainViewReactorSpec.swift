//
//  MainViewReactorSpec.swift
//  SoundMuseumTests
//
//  Created by Gunter on 2020/11/22.
//
import Nimble
import Quick
import Pure
import RxSwift
import RxBlocking

@testable import SoundMuseum

final class MainViewReactorSpec: QuickSpec {

  override func spec() {
    func createReactor(
      firestoreService: FirestoreSerivceStub = .init()
    ) -> MainViewReactor {
      let factory = MainViewReactor.Factory(dependency: .init(
        firestoreService: firestoreService
      ))
      let reactor = factory.create(payload: .init(
      ))
      _ = reactor.state
      return reactor
    }

    context("initialize 액션을 받았을 때") {
      it("로딩 중 입니다.") {
        // given
        let firestoreService = FirestoreSerivceStub()
        let reactor = createReactor(firestoreService: firestoreService)

        // when
        reactor.action.onNext(.initialize)

        // then
        expect(reactor.currentState.isLoading) == true
      }

      it("사운드 리스트를 가져옵니다.") {
        // given
        let fetchStub: () -> Observable<[Sound]> = { .just([
            Sound(name: "gunter", soundURL: "aa", imgURL: "bb"),
        ])}
        let firestoreService = FirestoreSerivceStub(fetchStub: fetchStub)
        let reactor = createReactor(firestoreService: firestoreService)

        // when
        reactor.action.onNext(.initialize)

        // then
        let executions = firestoreService.fetchSound()
        expect(try executions.toBlocking().single()).to(haveCount(1))
      }
    }

    context("필요한 API 요청이 끝나면") {
      it("로딩 중이 아닙니다.") {
        // given
        let fetchStub: () -> Observable<[Sound]> = { .just([
            Sound(name: "gunter", soundURL: "aa", imgURL: "bb"),
        ])}
        let firestoreService = FirestoreSerivceStub(fetchStub: fetchStub)
        let reactor = createReactor(firestoreService: firestoreService)

        // when
        reactor.action.onNext(.initialize)

        // then
        expect(reactor.currentState.isLoading) == false
      }
    }
  }
}

extension Factory where Module == MainViewReactor {

  static func dummy() -> Factory {
    return Factory(dependency: .init(
      firestoreService: FirestoreSerivceStub()
    ))
  }
}

