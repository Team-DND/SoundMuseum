//
//  SectionedViewDataSourceType+Transition.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import RxCocoa
import RxDataSources_Texture

extension SectionedViewDataSourceType {
  func preferredNodeTransition<S: AnimatableSectionModelType>(for diff: [Changeset<S>]) -> NodeTransition {
    let hasDeletedSections: Bool = !diff.allSatisfy { $0.deletedSections.isEmpty }
    let hasInsertedSections: Bool = !diff.allSatisfy { $0.insertedSections.isEmpty }

    let hasDeletedItems: Bool = !diff.allSatisfy { $0.deletedItems.isEmpty }
    let hasInsertedItems: Bool = !diff.allSatisfy { $0.insertedItems.isEmpty }

    if (hasDeletedSections && hasInsertedSections) || (hasDeletedItems && hasInsertedItems) {
      return .reload
    } else {
      return .animated
    }
  }
}
