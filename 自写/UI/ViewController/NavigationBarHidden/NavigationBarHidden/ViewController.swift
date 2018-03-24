//
//  ViewController.swift
//  NavigationBarHidden
//
//  Created by luozhijun on 2017/12/14.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "First"
        view.backgroundColor = UIColor.orange
        
        let btn = UIButton(type: .system)
        view.addSubview(btn)
        btn.setTitle("Push to Next", for: .normal)
        btn.sizeToFit()
        btn.center = CGPoint(x: 100, y: 200)
        btn.addTarget(self, action: #selector(pushToNext), for: .touchUpInside)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func pushToNext() {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    
}

