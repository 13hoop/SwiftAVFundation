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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black
    avPlayerLayer = AVPlayerLayer(player: avPlayer)
    view.layer.insertSublayer(avPlayerLayer, at: 0)
    
    let playerItem = AVPlayerItem(url: movieUrl)
    avPlayer.replaceCurrentItem(with: playerItem)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    avPlayer.play() // Start the playback
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    avPlayerLayer.frame = view.bounds
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  // Force the view into landscape mode (which is how most video media is consumed.)
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.landscape
  }
}
