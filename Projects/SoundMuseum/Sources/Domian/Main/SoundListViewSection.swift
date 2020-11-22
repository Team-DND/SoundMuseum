//
//  SoundListViewSection.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import RxDataSources

struct SoundListViewSection: Equatable {
  enum Identity: Hashable {
    case activityIndicator
    case sounds
  }

  var identity: Identity
  var items: [Item]
}

extension SoundListViewSection: AnimatableSectionModelType {
  enum Item: Hashable {
    case activityIndicator
    case sounds(Sound)
  }

  init(original: SoundListViewSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension SoundListViewSection.Item: IdentifiableType {
  var identity: Int {
    return self.hashValue
  }
}
