//
//  ViewController.swift
//  aaaaaa
//
//  Created by luozhijun on 2017/3/23.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = "哈哈哈".encryptedString(with: .SHA512, isHmac: true, hmacKey: "tzVIhxznsUR2")
        print(value)
        print(value.1)
    }
}
