//
//  AudioPlayerNode.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/11/25.
//

import AsyncDisplayKit
import DndUI
import RxSwift
import RxCocoa

final class AudioPlayerNode: ASDisplayNode {

  // MARK: Constants

  private enum Metric {
    static let titleImageSize = 40.f
    static let playControlButtonSize = 24.f
    static let audioPlayerNodeHeightSize = 72.f
  }


  // MARK: UI

  private let titleImageNode = NetworkImageNode().then {
    $0.placeholderFadeDuration = 0.3
    $0.placeholderColor = .gray900
    $0.cornerRadius = Metric.titleImageSize / 2
  }
  private let titleTextNode = TextNode().then {
    $0.backgroundColor = .clear
  }
  private let currentTimeTextNode = TextNode().then {
    $0.backgroundColor = .clear
  }
  fileprivate let playControlButtonNode = ASButtonNode().then {
    $0.setImage(UIImage(named: "ic_play_circle"), for: .normal)
    $0.setImage(UIImage(named: "ic_pause_circle"), for: .selected)
    $0.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(.white)
    $0.cornerRadius = Metric.playControlButtonSize / 2
  }
  private let indicatorNode = ActivityIndicatorNode(style: .white)


  // MARK: Properties

  var isPlay: Bool? {
    didSet {
      self.playControlButtonNode.isSelected = isPlay ?? true
    }
  }
  var currentPlayTime: String {
    didSet {
      self.configureCurrentTimeTextNode()
    }
  }
  var isLoading: Bool = false {
    didSet {
      self.playControlButtonNode.isHidden = isLoading
      self.setNeedsLayout()
    }
  }


  // MARK: Initializing

  override init() {
    self.currentPlayTime = "00:00"
    super.init()
    self.automaticallyManagesSubnodes = true
    self.backgroundColor = UIColor.gray800.withAlphaComponent(0.9)
    self.layer.cornerRadius = 8
  }

  func showPlayerView(
    titleImageUrl: URL?,
    title: String
  ) {
    guard self.isHidden else { return }
    self.isHidden = false
    self.isPlay = true
    let startY = UIScreen.main.bounds.height
    let bottomOffset = 34.f
    let endY = startY - Metric.audioPlayerNodeHeightSize - bottomOffset
    self.frame.origin.y = startY
    if let url = titleImageUrl {
      self.titleImageNode.setImage(with: url)
    }
    self.currentPlayTime = "00:00"
    self.titleTextNode.attributedText = title.styled(with: Typo.h3Font(color: .gray100))

    ASPerformBlockOnMainThread {
      self.layer.removeAllAnimations()
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0,
        options: [.curveEaseOut, .allowUserInteraction],
        animations: {
          self.frame.origin.y = endY
        },
        completion: nil
      )
    }
  }

  func setPlayerView(
    titleImageUrl: URL?,
    title: String
  ) {
    self.currentPlayTime = "00:00"
    self.titleTextNode.attributedText = title.styled(with: Typo.h3Font(color: .gray100))
    if let url = titleImageUrl {
      self.titleImageNode.setImage(with: url)
    }
  }

  func hidePlayerView() {
    guard !self.isHidden else { return }
    let startY = UIScreen.main.bounds.height

    ASPerformBlockOnMainThread {
      self.layer.removeAllAnimations()
      UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1,
        initialSpringVelocity: 0,
        options: [.curveEaseOut, .allowUserInteraction],
        animations: {
          self.frame.origin.y = startY
        },
        completion: { _ in
          self.isHidden = true
        }
      )
    }
  }

  private func configureCurrentTimeTextNode() {
    self.currentTimeTextNode.attributedText = self.currentPlayTime.styled(with: Typo.labelFont(color: .gray600))
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return ASInsetLayoutSpec(
      insets: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
      child: self.playerLayoutElement()
    )
  }

  private func playerLayoutElement() -> ASLayoutElement {
    let spacing = UIScreen.main.bounds.width - 244
    let layoutElement: ASLayoutElement?

    if self.isLoading {
      layoutElement = self.indicatorNode.styled {
        $0.preferredSize.width = Metric.titleImageSize
        $0.preferredSize.height = Metric.titleImageSize
      }
      self.indicatorNode.startAnimating()
    } else {
      layoutElement = self.titleImageNode.styled {
        $0.preferredSize.width = Metric.titleImageSize
        $0.preferredSize.height = Metric.titleImageSize
      }
      self.indicatorNode.stopAnimating()
    }

    let titleImageAndtitleAndCurrentTextLayout = ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: .start,
      alignItems: .center,
      children: [
        layoutElement,
        SpacingLayout(width: 12),
        self.titleAndCurrentTextLayoutElement(),
      ].compactMap { $0 }
    )

    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 0,
      justifyContent: .start,
      alignItems: .center,
      children: [
        titleImageAndtitleAndCurrentTextLayout,
        SpacingLayout(width: spacing),
        self.playControlButtonNode.styled {
          $0.preferredSize.width = Metric.playControlButtonSize
          $0.preferredSize.height = Metric.playControlButtonSize
        }
      ]
    )
  }

  private func titleAndCurrentTextLayoutElement() -> ASLayoutElement {
    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 3,
      justifyContent: .start,
      alignItems: .stretch,
      children: [
        self.titleTextNode.styled {
          $0.width = 100
        },
        self.currentTimeTextNode,
      ]
    )
  }
}

extension Reactive where Base: AudioPlayerNode {
  var didTogglePlayControlButton: ControlEvent<Bool> {
    let source = self.base.playControlButtonNode.rx.tap
      .map { base.isPlay ?? true }
    return ControlEvent(events: source)
  }
}
