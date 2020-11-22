//
//  MainViewReactor.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import Pure
import ReactorKit
import RxSwift

final class MainViewReactor: Reactor, FactoryModule {

  // MARK: Module

  struct Dependency {
    let firestoreService: FirestoreSerivceProtocol
  }

  struct Payload {
  }

  enum Action {
    case initialize
  }

  enum Mutation {
    case setLoading(Bool)
    case setSoundsList([Sound])
    case updateSections
  }

  struct State {
    var sounds: [Sound]?
    var sections: [SoundListViewSection] = []
    var isLoading: Bool = false
  }


  // MARK: Properties

  private let dependency: Dependency
  private let payload: Payload
  let initialState: State


  // MARK: Initializing

  init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    self.payload = payload
    self.initialState = State(
      sounds: nil
    )
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialize:
      guard !self.currentState.isLoading else { return Observable.empty() }
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        self.fetchSounds(),
        Observable.just(Mutation.setLoading(false)),
        Observable.just(.updateSections),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setSoundsList(sounds):
      newState.sounds = sounds

    case .updateSections:
      newState.sections = []
      defer { newState.sections.removeDuplicates() }

      if newState.isLoading {
        let section = self.activityIndicatorSectionItem(state: state)
        newState.sections.append(section)
        break
      }

      if let section = self.soundsSectionItem(state: state) {
        newState.sections.append(section)
      }
    }

    return newState
  }

  private func fetchSounds() -> Observable<Mutation> {
    return self.dependency.firestoreService.fetchSound()
      .map(Mutation.setSoundsList)
      .catchError { _ in .empty() }
  }
}

extension MainViewReactor {
  private func soundsSectionItem(state: State) -> SoundListViewSection? {
    guard let sounds = state.sounds else { return nil }
    let sectionItems: [SoundListViewSection.Item] = sounds.map { sound in
      return .sounds(sound)
    }
    return SoundListViewSection(identity: .sounds, items: sectionItems)
  }

  private func activityIndicatorSectionItem(state: State) -> SoundListViewSection {
    return SoundListViewSection(identity: .activityIndicator, items: [.activityIndicator])
  }
}
