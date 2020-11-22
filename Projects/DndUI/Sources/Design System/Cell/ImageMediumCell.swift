//
//  ImageMediumCell.swift
//  DndUI
//
//  Created by Gunter on 2020/11/01.
//

import AsyncDisplayKit
import RxSwift
import RxTexture2
import Then
import BonMot

public final class ImageMediumCell: ASControlNode {

  // MARK: Properties

  public var imageUrl: URL? {
    didSet {
      self.updateImage()
    }
  }
  public var titleText: String? {
    didSet {
      self.updateTitleText()
    }
  }
  public var titleTextColor: UIColor? {
    didSet {
      self.updateTitleText()
    }
  }
  public var titleTextAlignment: NSTextAlignment {
    didSet {
      self.updateTitleText()
    }
  }
  public var mainText: String? {
    didSet {
      self.updateMainText()
    }
  }
  public var mainTextColor: UIColor? {
    didSet {
      self.updateMainText()
    }
  }
  public var mainTextAlignment: NSTextAlignment {
    didSet {
      self.updateMainText()
    }
  }
  public var didTapButton: () -> Void
  private let disposeBag = DisposeBag()

  // MARK: UI

  private var imageNode = NetworkImageNode().then {
    $0.placeholderColor = .gray100
    $0.placeholderFadeDuration = 0.3
    $0.contentMode = .scaleAspectFill
    $0.cornerRadius = 4
    $0.clipsToBounds = true
  }
  private var titleTextNode = TextNode().then {
    $0.backgroundColor = .clear
    $0.maximumNumberOfLines = 1
    $0.truncationMode = .byTruncatingTail
  }
  private var mainTextNode = TextNode().then {
    $0.backgroundColor = .clear
    $0.maximumNumberOfLines = 1
    $0.truncationMode = .byTruncatingTail
  }


  // MARK: Initializing

  public init(
    didTapButton: @escaping () -> Void = { }
  ) {
    self.titleTextAlignment = .left
    self.mainTextAlignment = .left
    self.didTapButton = didTapButton
    super.init()
    self.backgroundColor = .clear
    self.automaticallyManagesSubnodes = true
    self.bindTap()
  }


  // MARK: Configuring

  private func bindTap() {
    self.rx.tap
      .subscribe(onNext: { [weak self] _ in
        self?.didTapButton()
      })
      .disposed(by: self.disposeBag)
  }

  private func updateImage() {
    if let url = self.imageUrl {
      self.imageNode.setImage(with: url)
    }
  }

  private func updateTitleText() {
    if let textColor = self.titleTextColor {
      self.titleTextNode.attributedText = self.titleText?.styled(with: Typo.h3Font(color: textColor).byAdding([.alignment(self.titleTextAlignment)]))
    } else {
      self.titleTextNode.attributedText = self.titleText?.styled(with: Typo.h3Font(color: .gray900).byAdding([.alignment(self.titleTextAlignment)]))
    }
  }

  private func updateMainText() {
    if let textColor = self.mainTextColor {
      self.mainTextNode.attributedText = self.mainText?.styled(with: Typo.bodyFont(color: textColor).byAdding([.alignment(self.mainTextAlignment)]))
    } else {
      self.mainTextNode.attributedText = self.mainText?.styled(with: Typo.bodyFont(color: .gray800).byAdding([.alignment(self.mainTextAlignment)]))
    }
  }


  // MARK: Layout

  public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.imageLayoutSpec(),
        SpacingLayout(height: 12),
        self.titleTextNode,
        self.mainTextNode
      ]
    )
  }

  private func imageLayoutSpec() -> ASLayoutSpec {
    return ASRatioLayoutSpec(ratio: 1, child: self.imageNode)
  }
}


