//
//  ViewController.swift
//  SwiftAVFundation
//
//  Created by YongRen on 2017/6/17.
//  Copyright © 2017年 YongRen. All rights reserved.
//

import UIKit

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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setFrame()
    btn.addTarget(self, action: #selector(ViewController.palyBtnClick), for: .touchUpInside)
  }
  
  func setFrame(){
    view.backgroundColor = UIColor.lightGray

    view.addSubview(urlTextField)
    view.centerXAnchor.constraint(equalTo: urlTextField.centerXAnchor).isActive = true
    view.topAnchor.constraint(equalTo: urlTextField.topAnchor, constant: -20).isActive = true

    view.addSubview(btn)
    view.centerXAnchor.constraint(equalTo: btn.centerXAnchor).isActive = true
    view.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
  }
  
  func palyBtnClick() {
    print(#function)
    print(urlTextField.frame)
  }

}
