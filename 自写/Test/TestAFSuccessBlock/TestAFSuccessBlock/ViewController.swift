//
//  ViewController.swift
//  TestAFSuccessBlock
//
//  Created by luozhijun on 2016/10/20.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

public let view_array_key = "view_array"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 为了证明给同事AF的回调block不会保存, 从而不会引起循环引用, 故写了此测试工程
        let person = Person()
        person.request()
        
        NSLog("------")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
