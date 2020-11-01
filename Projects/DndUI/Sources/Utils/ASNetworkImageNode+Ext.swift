//
//  ASNetworkImageNode+Ext.swift
//  DndUI
//
//  Created by Gunter on 2020/11/01.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

extension ASNetworkImageNode {
  public func setImage(with url: URL) {
    self.url = url
    self.clearImageAndURL()
  }

  private func clearImageAndURL() {
    self.image = nil
    self.url = nil
  }
}

extension Reactive where Base: ASNetworkImageNode {
  public func image() -> Binder<URL> {
    return Binder(self.base, scheduler: CurrentThreadScheduler.instance) { imageNode, url in
      imageNode.setImage(with: url)
    }
  }
}
