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
  lazy var slider: UISlider = {
    let elm = UISlider()
    elm.minimumValue = 0
    elm.translatesAutoresizingMaskIntoConstraints = false
    return elm
  }()
  lazy var totalTimeLb: UILabel = {
    let elm = UILabel()
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.text = "00:00"
    return elm
  }()
  lazy var currentTimeLb: UILabel = {
    let elm = UILabel()
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.text = "00:00"
    return elm
  }()

  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
  
  var playerLayer: AVPlayerLayer?
  var player:AVPlayer? {
    didSet {
      playerLayer = AVPlayerLayer(player: player)
      layer.addSublayer(playerLayer!)
      updateStatus()
    }
  }
  
  let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
  var periodicTimer: Any?
  func updateStatus() {
    playerLayer?.addObserver(self, forKeyPath: "readyForDisplay", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
    
    periodicTimer = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: {[weak self] stepTime in
      let x = self?.cmTimeToStr(cmTimeSeconds: stepTime.seconds)
      print("~~> \(String(describing: x))")
      self?.currentTimeLb.text = x
      self?.slider.value = Float(stepTime.seconds)
    })
  }
  
  deinit {
    playerLayer?.removeObserver(self, forKeyPath: "readyForDisplay")
    player?.removeTimeObserver(periodicTimer!)
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if (playerLayer?.isReadyForDisplay)! {
      activityIndicator.stopAnimating()
      slider.maximumValue = Float(player!.currentItem!.duration.seconds)
      totalTimeLb.text = cmTimeToStr(cmTimeSeconds: player!.currentItem!.duration.seconds)
    }
  }
  
  func cmTimeToStr(cmTimeSeconds: Double) -> String {
    let x = cmTimeSeconds
    let m = lround(x / 60)
    let s = lround(x) % 60
    print("\(m) - \(s)")
    return String(format: "%02d:%02d", m, s)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setViews()
    activityIndicator.startAnimating()
    
//    slider.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
  }
  
  func setViews() {
    activityIndicator.hidesWhenStopped = true
    addSubview(activityIndicator)
    
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
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer?.frame = bounds
    activityIndicator.frame = bounds
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
