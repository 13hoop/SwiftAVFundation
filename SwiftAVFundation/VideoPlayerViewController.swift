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
  let movieUrl: URL = URL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!
  
  var timeObserver: Any!
  let invisibleButton = UIButton()
  let timeRemainingLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    avPlayerLayer = AVPlayerLayer(player: avPlayer)
    view.layer.insertSublayer(avPlayerLayer, at: 0)
    
    view.addSubview(invisibleButton)
    invisibleButton.addTarget(self, action: #selector(invisibleButtonTapped),for: .touchUpInside)
    
    timeRemainingLabel.textColor = .white
    view.addSubview(timeRemainingLabel)
    
    let playerItem = AVPlayerItem(url: movieUrl)
    avPlayer.replaceCurrentItem(with: playerItem)
    
    let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
    timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (elapsedTime) in
//      print( "~~~~ \(CMTimeGetSeconds(elapsedTime))")
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
  
  private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
    let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
    timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
  }
  
  deinit {
    avPlayer.removeTimeObserver(timeObserver)
  }
  
  func invisibleButtonTapped(sender: UIButton) {
    let playerIsPlaying = avPlayer.rate > 0
    if playerIsPlaying {
      avPlayer.pause()
    } else {
      avPlayer.play()
    }
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
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  // Force the view into landscape mode (which is how most video media is consumed.)
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.landscape
  }
}
