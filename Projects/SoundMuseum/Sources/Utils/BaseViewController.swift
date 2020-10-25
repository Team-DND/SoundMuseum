//
//  BaseViewController.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/10/25.
//

import AsyncDisplayKit
import RxSwift

class BaseViewController: ASDKViewController<ASDisplayNode> {

  // MARK: Initializing
  override init() {
    super.init(node: ASDisplayNode.init())
    self.node.automaticallyManagesSubnodes = true
    self.node.automaticallyRelayoutOnSafeAreaChanges = true
    self.node.layoutSpecBlock = { [weak self] (node, constraintedSize) -> ASLayoutSpec in
        return self?.layoutSpecThatFits(constraintedSize) ?? ASLayoutSpec()
    }
  }

  @available(*, unavailable)
  required convenience init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy private(set) var className: String = {
    return type(of: self).description().components(separatedBy: ".").last ?? ""
  }()

  deinit {
    log.verbose("DEINIT: \(self.className)")
  }

  override func viewDidLoad() {
      super.viewDidLoad()
      self.setNeedsStatusBarAppearanceUpdate()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
      if #available(iOS 13, *) {
          return .lightContent
      } else {
          return .default
      }
  }


  // MARK: Rx

  var disposeBag = DisposeBag()


  // MARK: Layout Spec

  func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASLayoutSpec()
  }


  // MARK: Layout

  func layout() {
  }

}
