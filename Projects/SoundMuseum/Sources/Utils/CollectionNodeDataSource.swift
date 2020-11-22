//
//  CollectionNodeDataSource.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/22.
//

import RxDataSources_Texture

final class CollectionNodeDataSource<S: AnimatableSectionModelType>: RxASCollectionSectionedAnimatedDataSource<S> {
  init(
    decideNodeTransition: @escaping RxDataSources_Texture.RxASCollectionSectionedAnimatedDataSource<S>.DecideNodeTransition = { dataSource, _, diff in
      return dataSource.preferredNodeTransition(for: diff)
    },
    configureCellBlock: @escaping ConfigureCellBlock,
    configureSupplementaryNode: ConfigureSupplementaryNode? = nil
  ) {
    super.init(
      animationConfiguration: AnimationConfiguration(animated: false),
      decideNodeTransition: decideNodeTransition,
      configureCellBlock: configureCellBlock,
      configureSupplementaryNode: configureSupplementaryNode,
      moveItem: { _, _, _ in () },
      canMoveItemWith: { _, _ in false }
    )
  }
}
