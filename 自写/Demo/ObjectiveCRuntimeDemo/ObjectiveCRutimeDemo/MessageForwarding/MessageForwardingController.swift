//
//  MessageForwardingController.swift
//  ObjectiveCRutimeDemo
//
//  Created by luozhijun on 2017/3/17.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class MessageForwardingController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mf = MessageForwarding()
        mf.action()
    }

}
