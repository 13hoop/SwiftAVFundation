//
//  ViewController.swift
//  SwiftAVFundation
//
//  Created by YongRen on 2017/6/17.
//  Copyright © 2017年 YongRen. All rights reserved.
//

import UIKit
import AVFoundation

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
  
  let player = AVPlayer()
  //  let movieUrl: URL = URL(string: "https://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!
  //
  let movieUrl: URL = URL(string: "http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4")!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setFrame()
    videoPrepared()
    
    btn.addTarget(self, action: #selector(ViewController.palyBtnClick), for: .touchUpInside)
  }
  
  func setFrame() {
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
  
    func videoPrepared() {
    playView.player = player
    let playItem = AVPlayerItem(url: movieUrl)
    player.replaceCurrentItem(with: playItem)
    
    playView.slider.addTarget(self, action: #selector(ViewController.sliderChanged), for: .valueChanged)
    playView.slider.addTarget(self, action: #selector(ViewController.sliderBeganTracking), for: .touchDown)
    playView.slider.addTarget(self, action: #selector(ViewController.sliderEndedTracking), for: [.touchUpInside, .touchUpOutside])
  }
  
  
  //MARK: -- event controller
  func palyBtnClick() {
    print(" click: \(playView.frame)")
    if player.rate > 0 {
      self.player.pause()
    }else {
      self.player.play()
    }
    
    //    let vc = VideoPlayerViewController()
    //    navigationController?.pushViewController(vc, animated: false)
  }
  
  var playRate: Float = 0.0
  func sliderChanged(slider: UISlider) {
    print("\(slider.value)")
    self.playView.updateTime(timeSeconds: Double(slider.value))
  }
  
  func sliderBeganTracking(slider: UISlider) {
    self.playRate = player.rate
    if player.rate > 0.0 {
      player.pause()
    }
  }
  
  func sliderEndedTracking(slider: UISlider) {
    player.seek(to: CMTimeMakeWithSeconds(Float64(slider.value), Int32(1.0))) { (completed: Bool) -> Void in
        if self.playRate > 0.0 {
          self.player.play()
        }
    }
  }
}
