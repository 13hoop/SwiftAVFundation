//
//  VideoPlayerViewController.swift
//  SwiftAVFundation
//
//  Created by YongRen on 2017/6/18.
//  Copyright © 2017年 YongRen. All rights reserved.
//
import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
  let avPlayer = AVPlayer()
  var avPlayerLayer: AVPlayerLayer!
//  let movieUrl: URL = URL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!
//  http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4
  let movieUrl: URL = URL(string: "http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4")!
  
  var timeObserver: Any!
  let invisibleButton = UIButton()
  let timeRemainingLabel = UILabel()
  let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let seekSlider = UISlider()
  var playerRateBeforeSeek: Float = 0

  var playbackLikelyToKeepUpContext = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    avPlayerLayer = AVPlayerLayer(player: avPlayer)
    view.layer.insertSublayer(avPlayerLayer, at: 0)
    
    view.addSubview(invisibleButton)
    invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped),for: .touchUpInside)
    
    view.addSubview(seekSlider)
    seekSlider.addTarget(self, action: #selector(sliderBeganTracking),
                         for: .touchDown)
    seekSlider.addTarget(self, action: #selector(sliderEndedTracking),
                         for: [.touchUpInside, .touchUpOutside])
    seekSlider.addTarget(self, action: #selector(sliderValueChanged),
                         for: .valueChanged)
    
    loadingIndicatorView.hidesWhenStopped = true
    view.addSubview(loadingIndicatorView)
    avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp", options: .new, context: &playbackLikelyToKeepUpContext)

    timeRemainingLabel.textColor = .white
    view.addSubview(timeRemainingLabel)
    
    let playerItem = AVPlayerItem(url: movieUrl)
    avPlayer.replaceCurrentItem(with: playerItem)
    
    let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
    timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (elapsedTime) in
      self.observeTime(elapsedTime: elapsedTime)

    })
  }
  
  private func observeTime(elapsedTime: CMTime) {
    let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
//    if isfinite(duration) {
      let elapsedTime = CMTimeGetSeconds(elapsedTime)
      updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
//    }
  }
  
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    print("\(context!)===========")
    if context == &playbackLikelyToKeepUpContext {
      if avPlayer.currentItem!.isPlaybackLikelyToKeepUp {
        loadingIndicatorView.stopAnimating()
      } else {
        loadingIndicatorView.startAnimating()
      }
    }
  }
  
  private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
    let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
    timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
  }
  
  deinit {
    avPlayer.removeTimeObserver(timeObserver)
    avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
  }
  
  func invisibleButtonTapped(sender: UIButton) {
    let playerIsPlaying = avPlayer.rate > 0
    if playerIsPlaying {
      avPlayer.pause()
    } else {
      avPlayer.play()
    }
  }
  
  func sliderBeganTracking(slider: UISlider) {
    playerRateBeforeSeek = avPlayer.rate
    avPlayer.pause()
  }
  
  func sliderEndedTracking(slider: UISlider) {
    let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
    let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
    updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
    
    avPlayer.seek(to: CMTimeMakeWithSeconds(elapsedTime, 100)) { (completed: Bool) -> Void in
      if self.playerRateBeforeSeek > 0 {
        self.avPlayer.play()
      }
    }
  }
  
  func sliderValueChanged(slider: UISlider) {
    let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
    let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
    updateTimeLabel(elapsedTime: elapsedTime, duration: videoDuration)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadingIndicatorView.startAnimating()

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    avPlayer.play() // Start the playback
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    avPlayerLayer.frame = view.bounds
    invisibleButton.frame = view.bounds
    let controlsHeight: CGFloat = 30
    let controlsY: CGFloat = view.bounds.size.height - controlsHeight
    timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
    seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width,
                              y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
    loadingIndicatorView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)

  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  // Force the view into landscape mode (which is how most video media is consumed.)
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.landscape
  }
}
