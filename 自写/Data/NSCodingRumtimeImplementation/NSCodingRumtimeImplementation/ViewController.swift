//
//  ViewController.swift
//  NSCodingRumtimeImplementation
//
//  Created by luozhijun on 2016/12/23.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var testModel = TestModel()
    let path      = NSHomeDirectory() + "/temp.data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func archive(_ sender: Any) {
        if NSKeyedArchiver.archiveRootObject(testModel, toFile: path) {
            UIAlertView(title: nil, message: "Archive successed", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
    
    @IBAction func unarchive(_ sender: Any) {
        if let temp = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? TestModel {
            print(temp)
            UIAlertView(title: nil, message: "Unarchive successed", delegate: nil, cancelButtonTitle: "确定").show()
        }
    }
}

class TestModel: CodingObject {
    var nilString:      String?
    var name            = "aaa"
    var age             = 10
    var colorValues     = [0x101010, 0x001201, 0x111210]
    var doubleValues    = [1.2, 1.3, 2.5, 10.9999934]
    var height          = 1.801
    var friends         = ["Harry", "Bill"]
    var nilSubModel:    SubModel?
    var nilModelArray:  [TestModel]?
    var nilDictionary:  [String: Any]?
    var subModel        = SubModel()
    var subModels       = [SubModel(), SubModel()]
    var dictionaryValue: [String: Any] = ["1": "lYcHeeM", "2": "剑气箫心", "3": SubModel()]
}

class SubModel: CodingObject {
    var nilDouble:   Double?
    var nilInt:      Int?
    var nilIntArray: [Int]?
    var count        = 10
    var pie          = 3.1415926
    var identifier   = "SubModel"
    var ids          = ["01231", "01232", "12310"]
}

