//
//  YRPlayView.swift
//  SwiftAVFundation
//
//  Created by YongRen on 2017/6/18.
//  Copyright © 2017年 YongRen. All rights reserved.
//

import UIKit
import AVFoundation

class YRPlayView: UIView {
  var slider: UISlider = {
    let elm = UISlider()
    elm.minimumValue = 0
    elm.translatesAutoresizingMaskIntoConstraints = false
    return elm
  }()
  private lazy var totalTimeLb: UILabel = {
    let elm = UILabel()
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.text = "00:00"
    return elm
  }()
  private lazy var currentTimeLb: UILabel = {
    let elm = UILabel()
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.text = "00:00"
    return elm
  }()
  private var playerItemContext = 0

  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
  
  private var playerLayer: AVPlayerLayer?
  var player:AVPlayer? {
    didSet {
      playerLayer = AVPlayerLayer(player: player)
      layer.addSublayer(playerLayer!)
      updateStatus()
    }
  }
  
  private let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
  private var periodicTimer: Any?
  private func updateStatus() {
    playerLayer?.addObserver(self, forKeyPath: #keyPath(AVPlayerLayer.isReadyForDisplay), options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: &playerItemContext)
    
    player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp), options: [.old, .new], context: &playerItemContext)
    
    NotificationCenter.default.addObserver(self, selector: #selector(videoEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)


    periodicTimer = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { stepTime in
      self.updateTime(timeSeconds: stepTime.seconds)
    })
  }
  
  func updateTime(timeSeconds: Double) {
    let x = self.cmTimeToStr(cmTimeSeconds: timeSeconds)
    self.currentTimeLb.text = x
    self.slider.setValue(Float(timeSeconds), animated: false)
  }
  
  func videoEnded() {
    print("  ended here ")
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

    // Only handle observations for the playerItemContext
    guard context == &playerItemContext else {
      super.observeValue(forKeyPath: keyPath,
                         of: object,
                         change: change,
                         context: context)
      return
    }
    
    if keyPath == #keyPath(AVPlayerLayer.isReadyForDisplay) {
      if (playerLayer?.isReadyForDisplay)! {
        print(" --#keyPath: isReadyForDisplay-- ")
        activityIndicator.stopAnimating()
        slider.maximumValue = Float(player!.currentItem!.duration.seconds)
        totalTimeLb.text = cmTimeToStr(cmTimeSeconds: player!.currentItem!.duration.seconds)
      }
    }
    
    if keyPath == #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp) {
      print(" --#keyPath: isPlaybackLikelyToKeepUp-- ")

      if (player?.currentItem?.isPlaybackLikelyToKeepUp)! {
        activityIndicator.stopAnimating()
      }else {
        activityIndicator.startAnimating()
      }
    }
  }
  
   private func cmTimeToStr(cmTimeSeconds: Double) -> String {
    let x = cmTimeSeconds
    let m = lround(x / 60)
    let s = lround(x) % 60
//    print("\(m) - \(s)")
    return String(format: "%02d:%02d", m, s)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setViews()
    activityIndicator.startAnimating()
  }
  
  private func setViews() {
    
    addSubview(slider)
    slider.heightAnchor.constraint(equalToConstant: 60)
    slider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    
    addSubview(totalTimeLb)
    addSubview(currentTimeLb)

    totalTimeLb.heightAnchor.constraint(equalTo: slider.heightAnchor).isActive = true
    totalTimeLb.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
    totalTimeLb.leftAnchor.constraint(equalTo: slider.rightAnchor, constant: 8).isActive = true
    totalTimeLb.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    
    currentTimeLb.heightAnchor.constraint(equalTo: slider.heightAnchor).isActive = true
    currentTimeLb.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    currentTimeLb.rightAnchor.constraint(equalTo: slider.leftAnchor, constant: 0).isActive = true
    currentTimeLb.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor, constant: 8).isActive = true
    currentTimeLb.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
    
    activityIndicator.hidesWhenStopped = true
    addSubview(activityIndicator)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer?.frame = bounds
    activityIndicator.frame = bounds
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    playerLayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayerLayer.isReadyForDisplay), context: &playerItemContext)
    player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp), context: &playerItemContext)
    player?.removeTimeObserver(periodicTimer!)
  }
}
