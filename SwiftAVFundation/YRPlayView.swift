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
  var player:AVPlayer? {
    didSet {
      
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let playLayer = AVPlayerLayer(player: player)
    layer.insertSublayer(playLayer, at: 0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
