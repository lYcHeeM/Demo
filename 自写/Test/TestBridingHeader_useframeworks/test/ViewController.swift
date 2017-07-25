//
//  ViewController.swift
//  test
//
//  Created by luozhijun on 2016/10/18.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit
import AFNetworking
import IQKeyboardManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let view = MyView()
        view.backgroundColor = UIColor.redColor()
        view.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(view)
        
        let mgr = AFHTTPSessionManager()
        print(mgr)
        
        let keyboardMgr = IQKeyboardManager.sharedManager()
        print(keyboardMgr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

