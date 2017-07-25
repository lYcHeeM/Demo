//
//  ViewController.swift
//  ZJToast
//
//  Created by luozhijun on 2017/7/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toast = ZJToast(message: "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈", style: .progress, needsCancelButton: true)
        view.addSubview(toast)
        toast.progress = 0.5
        
        let string: String? = nil
        let c = string?.components(separatedBy: ";")
        print(c)
    }


}

