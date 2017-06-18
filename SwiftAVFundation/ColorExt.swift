//
//  ColorExt.swift
//  SwiftAVFundation
//
//  Created by YongRen on 2017/6/17.
//  Copyright © 2017年 YongRen. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(hex: String) {
    let str = hex.hasPrefix("#") ? hex.substring(from: hex.index(after: hex.startIndex)) : hex
    let scanner = Scanner(string: str)
    scanner.scanLocation = 0
    var rgbValue: UInt64 = 0

    scanner.scanHexInt64(&rgbValue)
    let r = (rgbValue & 0xff0000) >> 16
    let g = (rgbValue & 0xff00) >> 8
    let b = rgbValue & 0xff
    
    self.init(
      red: CGFloat(r) / 0xff,
      green: CGFloat(g) / 0xff,
      blue: CGFloat(b) / 0xff, alpha: 1
    )
  }
}
