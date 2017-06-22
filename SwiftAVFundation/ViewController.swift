//
//  ViewController.swift
//  SwiftAVFundation
//
//  Created by YongRen on 2017/6/17.
//  Copyright © 2017年 YongRen. All rights reserved.
//


// https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8
import UIKit
import AVFoundation

protocol errorMessageDelegate {
  func errorMessageChanged(newVal: String)
}

class ViewController: UIViewController {
  
  var btn: UIButton = {
    let elm = UIButton()
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.widthAnchor.constraint(equalToConstant: 40).isActive = true
    elm.heightAnchor.constraint(equalToConstant: 20).isActive = true
    elm.setTitle("播放", for: .normal)
    elm.setTitleColor(.red, for: .highlighted)
    return elm
  }()
  var urlTextField: UITextField = {
    let elm = UITextField()
    elm.backgroundColor = UIColor(hex: "eeeeee")
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.widthAnchor.constraint(equalToConstant: 300).isActive = true
    elm.heightAnchor.constraint(equalToConstant: 30).isActive = true
    elm.placeholder = "input url here"
    return elm
  }()
  var playView: YRPlayView = {
    let elm = YRPlayView()
    elm.translatesAutoresizingMaskIntoConstraints = false
    elm.backgroundColor = .red
    return elm
  }()

//  var url:URL = URL(fileURLWithPath: "Bach.mp4", isDirectory: true)
//  let url: URL = URL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!
//  var urlAsset: AVURLAsset = AVURLAsset(url: NSURL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")! as URL, options: [:])
//  var player = AVPlayer(url: NSURL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")! as URL)
//  var playerItem: AVPlayerItem?
//  
//  var timeObserver: AnyObject!
//  
//  var errorDelegate:errorMessageDelegate? = nil
//  var errorMessage = "" {
//    didSet {
//      if let delegate = self.errorDelegate {
//        delegate.errorMessageChanged(newVal: self.errorMessage)
//      }
//    }
//  }
  
  
  let player = AVPlayer()
  var playerLayer: AVPlayerLayer!
  let movieUrl: URL = URL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    setFrame()
    
    playerLayer = AVPlayerLayer(player: player)
    self.playView.layer.addSublayer(playerLayer)
    
    let playerItem = AVPlayerItem(url: movieUrl)
    player.replaceCurrentItem(with: playerItem)
    
    btn.addTarget(self, action: #selector(ViewController.palyBtnClick), for: .touchUpInside)
//    
//    let statusKey = "tracks"
//    let keys = [statusKey, "loaded"]
//    self.urlAsset.loadValuesAsynchronously(forKeys: keys) {
////      var error: Error? = nil
//      var error: NSError? = nil
//      DispatchQueue.main.async {
//        let status: AVKeyValueStatus = self.urlAsset.statusOfValue(forKey: statusKey, error: &error)
//
//        if status == AVKeyValueStatus.loaded {
//          self.playerItem = AVPlayerItem(asset: self.urlAsset)
//          self.player = AVPlayer(playerItem: self.playerItem)
//        }else {
//          print(error!)
//        }
//      }
//    }
    
//    NotificationCenter.default.addObserver(
//      forName: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime,
//      object: nil,
//      queue: nil,
//      using: { notification in
//        print("Status: Failed to continue")
//        self.errorMessage = "Stream was interrupted"
//    })
//    
//    print("Initializing new player")
  }
  
  func palyerItemDidReachEnd(notify: NSNotification) {
    
  }
  
//  func watchSlider() {
//    let stepTime: CMTime = CMTimeMakeWithSeconds(1.0, 10)
//    self.player.addPeriodicTimeObserver(forInterval: stepTime, queue: nil)  { (elapsedTime: CMTime) -> Void in
//      // up scrubber UI here
//      print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
//      
//    }
//  }
  
  func setFrame(){
    view.backgroundColor = UIColor.lightGray
    
    view.addSubview(urlTextField)
    view.centerXAnchor.constraint(equalTo: urlTextField.centerXAnchor).isActive = true
    view.topAnchor.constraint(equalTo: urlTextField.topAnchor, constant: -20).isActive = true
    
    view.addSubview(btn)
    view.centerXAnchor.constraint(equalTo: btn.centerXAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: btn.bottomAnchor, constant: 20).isActive = true
  
    view.addSubview(playView)
    playView.widthAnchor.constraint(equalToConstant: YRRule.W_Screen).isActive = true
    playView.heightAnchor.constraint(equalToConstant: YRRule.H_Screen / 2).isActive = true
    playView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    playView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: 30).isActive = true
  }
  
  var isPlaying: Bool = false
  func palyBtnClick() {

    playerLayer.frame = playView.bounds
  
    if isPlaying {
      self.player.pause()
      isPlaying = false
    }else {
      self.player.play()
      isPlaying = true
    }
    
//    let vc = VideoPlayerViewController()
//    navigationController?.pushViewController(vc, animated: false)
  }
  
}
