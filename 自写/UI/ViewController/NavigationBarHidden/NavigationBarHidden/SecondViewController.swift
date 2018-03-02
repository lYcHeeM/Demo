//
//  SecondViewController.swift
//  NavigationBarHidden
//
//  Created by luozhijun on 2017/12/14.
//  Copyright © 2017年 luozhijun. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "second"
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
