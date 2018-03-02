//
//  ViewController.swift
//  ProtectNavigationPanGesture
//
//  Created by luozhijun on 2018/2/27.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }

}
