//
//  SelfSuperController.swift
//  ObjectiveCRutimeDemo
//
//  Created by luozhijun on 2017/3/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class SelfSuperController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.classForCoder)
        print(super.classForCoder)
    }

}
