//
//  ActivityIndicatorNode.swift
//  DndUI
//
//  Created by Gunter on 2020/11/28.
//

import AsyncDisplayKit
import RxCocoa
import RxSwift

public final class ActivityIndicatorNode: ASDisplayNode {

  // MARK: Properties

  private let activityIndicatorStyle: UIActivityIndicatorView.Style


  // MARK: UI

  private var indicatorView: UIActivityIndicatorView? {
    return self.view as? UIActivityIndicatorView
  }


  // MARK: Initializing

  public init(style: UIActivityIndicatorView.Style) {
    self.activityIndicatorStyle = style
    super.init()
    self.setViewBlock {
      return UIActivityIndicatorView(style: style)
    }
    self.isUserInteractionEnabled = false
  }


  // MARK: Sizing

  public override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
    switch self.activityIndicatorStyle {
    case .large, .whiteLarge:
      return CGSize(width: 37, height: 37)

    case .medium, .white, .gray:
      return CGSize(width: 20, height: 20)

    @unknown default:
      #if DEBUG
      fatalError()
      #else
      return CGSize(width: 20, height: 20)
      #endif
    }
  }


  // MARK: Animating

  public func startAnimating() {
    ASPerformBlockOnMainThread {
      self.indicatorView?.startAnimating()
    }
  }

  public func stopAnimating() {
    ASPerformBlockOnMainThread {
      self.indicatorView?.stopAnimating()
    }
  }
}

extension Reactive where Base: ActivityIndicatorNode {
  public var isAnimating: Binder<Bool> {
    return Binder(self.base) { node, isAnimating in
      if isAnimating {
        node.startAnimating()
      } else {
        node.stopAnimating()
      }
    }
  }
}
