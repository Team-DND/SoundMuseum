//
//  ViewController.swift
//  SoundMuseum
//
//  Created by Gunter on 2020/10/25.
//

import AsyncDisplayKit
import ReactorKit
import RxViewController
import AVFoundation
import BonMot
import DndUI
import Then
import Pure
import GoogleMobileAds
import MediaPlayer

class MainViewController: BaseViewController, View, FactoryModule {

  // MARK: Module

  struct Dependency {
  }

  struct Payload {
    let reactor: MainViewReactor
  }


  // MARK: Constants

  private enum Metric {
    static let itemSpacing = 15.f
    static let padding = 12.f
  }


  // MARK: Properties

  private let dependency: Dependency
  private let payload: Payload
  private var currentAudioURL: URL?
  private var player: AVPlayer!
  private var playerObserver: Any?
  private var isFirstPlay: Bool = true
  private var currentSound: Sound?
  private var interstitial: GADInterstitial!
  private lazy var dataSource = self.createDataSource()


  // MARK: UI

  private let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout()).then {
    $0.backgroundColor = .clear
    $0.alwaysBounceVertical = true
  }
  private let audioPlayerNode = AudioPlayerNode().then {
    $0.isHidden = true
  }


  // MARK: Initializing

  required init(dependency: Dependency, payload: Payload) {
    defer { self.reactor = payload.reactor }
    self.dependency = dependency
    self.payload = payload
    super.init()
    self.node.backgroundColor = .white
  }

  private func createDataSource() -> CollectionNodeDataSource<SoundListViewSection> {
    let dataSource = CollectionNodeDataSource<SoundListViewSection>(
      configureCellBlock: { [weak self] dataSource, collectionNode, indexPath, sectionItem in
        let sectionWidth = collectionNode.constrainedSizeForCalculatedLayout.max.width
        switch sectionItem {
        case let .sounds(sound):
          return { [weak self] in
            guard let self = self else { return ASCellNode() }
            let width = floor((sectionWidth - Metric.itemSpacing) / 2)
            let node = ImageMediumCell {
              self.currentSound = sound
              if self.isFirstPlay {
                self.playSound(url: URL(string: sound.soundURL))
                self.audioPlayerNode.showPlayerView(
                  titleImageUrl: URL(string: sound.imgURL),
                  title: sound.name
                )
              } else {
                self.showAdMob()
              }
              self.isFirstPlay = false
            }
            node.titleTextAlignment = .center
            node.titleText = sound.name
            node.imageUrl = URL(string: sound.imgURL)
            node.titleTextColor = .gray100
            return ASCellNode(wrapping: node).styled {
              $0.preferredLayoutSize.width = ASDimension(unit: .points, value: width)
            }
          }
        case .activityIndicator:
          return { ActivityIndicatorCellNode() }
        }
      })
    return dataSource
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.node.backgroundColor = .gray900
    self.navigationController?.navigationBar.isHidden = true
    self.collectionNode.delegate = self
    interstitial = createAndLoadInterstitial()
  }

  private func createAndLoadInterstitial() -> GADInterstitial {
    let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
    interstitial.delegate = self
    interstitial.load(GADRequest())
    return interstitial
  }


  // MARK: Binding

  func bind(reactor: MainViewReactor) {
    self.rx.viewDidLoad
      .map { Reactor.Action.initialize }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    reactor.state.map { $0.sections }
      .distinctUntilChanged()
      .bind(to: self.collectionNode.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.audioPlayerNode.rx.didTogglePlayControlButton
      .subscribe(onNext: { [weak self] isPlay in
        guard let self = self else { return }
        isPlay ? self.pauseSound() : self.playSound()
      })
      .disposed(by: self.disposeBag)
  }

  private func playSound(url: URL?) {
    guard let url = url else { return }
    let playerItem = AVPlayerItem(url: url)
    if let observer = self.playerObserver {
      self.player.removeTimeObserver(observer)
      self.playerObserver = nil
    }
    self.player = AVPlayer(playerItem: playerItem)
    self.audioPlayerNode.isLoading = true
    self.player.play()
    self.setupRemoteTransportControls()
    self.addPeriodicTimeObserver()
  }

  private func playSound() {
    self.player.play()
    self.audioPlayerNode.isPlay = true
  }

  private func pauseSound() {
    self.player.pause()
    self.audioPlayerNode.isPlay = false
  }

  private func setupNowPlaying(playerItem: AVPlayerItem) {
    guard let sound = self.currentSound else { return }
    guard let imgURL = URL(string: sound.imgURL) else { return }
    var nowPlayingInfo = [String : Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = sound.name
    do {
      let data = try Data(contentsOf: imgURL)
      if let image = UIImage(data: data) {
        nowPlayingInfo[MPMediaItemPropertyArtwork] =
          MPMediaItemArtwork(boundsSize: image.size) { size in
            return image
          }
      }
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
      nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player.rate
      MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    } catch {
      log.error(error)
    }
  }

  func setupRemoteTransportControls() {
    let commandCenter = MPRemoteCommandCenter.shared()
    commandCenter.playCommand.addTarget { [unowned self] event in
      if self.player.rate == 0.0 {
        self.playSound()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime().seconds
        return .success
      }
      return .commandFailed
    }
    commandCenter.pauseCommand.addTarget { [unowned self] event in
      if self.player.rate == 1.0 {
        self.pauseSound()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.player.currentTime().seconds
        return .success
      }
      return .commandFailed
    }
  }

  private func addPeriodicTimeObserver() {
    let interval = CMTime(seconds:1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    let mainQueue = DispatchQueue.main
    self.playerObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] progressTime in
      guard let self = self else { return }
      if let totalDuration = self.player?.currentItem?.duration, let currentItem = self.player.currentItem, !CMTimeGetSeconds(totalDuration).isNaN {
        if self.audioPlayerNode.isLoading {
          self.audioPlayerNode.isLoading = false
          self.setupNowPlaying(playerItem: currentItem)
        }
        let totalSeconds = Int(CMTimeGetSeconds(totalDuration))
        let currentSeconds = Int(CMTimeGetSeconds(progressTime))
        if currentSeconds == totalSeconds {
          self.audioPlayerNode.isLoading = true
          self.player.seek(to: CMTime.zero)
          self.player.play()
        }
        self.audioPlayerNode.currentPlayTime = self.secondsToHoursMinutesSecondsString(seconds: currentSeconds)
      }
    }
  }

  private func secondsToHoursMinutesSecondsString(seconds: Int) -> String {
    let (_, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: seconds)
    return "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
  }

  private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
  }

  private func showAdMob() {
    if interstitial.isReady {
      self.player.pause()
      interstitial.present(fromRootViewController: self)
    }
  }


  // MARK: Layout

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    let mainContentLayout = ASInsetLayoutSpec(
      insets: UIEdgeInsets(top: 40, left: Metric.padding, bottom: 0, right: Metric.padding),
      child: self.collectionNode
    )
    return ASOverlayLayoutSpec(
      child: mainContentLayout,
      overlay: self.playerLayoutElement()
    )
  }

  private func playerLayoutElement() -> ASLayoutElement {
    let playerLayout = ASInsetLayoutSpec(
      insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20),
      child: self.audioPlayerNode
    )

    return ASStackLayoutSpec(
      direction: .vertical,
      spacing: 0,
      justifyContent: .end,
      alignItems: .center,
      children: [
        playerLayout,
        SpacingLayout(height: 34),
      ]
    )
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, ASCollectionDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }
}

extension MainViewController: GADInterstitialDelegate {
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    interstitial = createAndLoadInterstitial()
    if let sound = self.currentSound {
      self.playSound(url: URL(string: sound.soundURL))
      self.audioPlayerNode.setPlayerView(
        titleImageUrl: URL(string: sound.imgURL),
        title: sound.name
      )
    }
  }
}

#if DEBUG
import Testables

extension MainViewController: Testable {
  final class TestableKeys: TestableKey<Self> {
    let collectionNode = \Self.collectionNode
    let audioPlayerNode = \Self.audioPlayerNode
  }
}
#endif
