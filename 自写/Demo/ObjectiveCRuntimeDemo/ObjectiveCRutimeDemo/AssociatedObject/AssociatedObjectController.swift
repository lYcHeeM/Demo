//
//  AssociatedObjectController.swift
//  ObjectiveCRutimeDemo
//
//  Created by luozhijun on 2017/3/20.
//  Copyright © 2017年 RickLuo. All rights reserved.
//

import UIKit

class AssociatedObjectController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let emptyData  = EmptyData()
        emptyData.name = "Rick"
        emptyDataModel = emptyData
        
        print(emptyDataModel.name)
    }

}

extension AssociatedObjectController {
    
    private struct AssociatedKeys {
        static var emptyDataModel: Int = 0
    }
    
    /// 其实这是"计算属性", 而不是"存储属性"
    var emptyDataModel: EmptyData {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyDataModel, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyDataModel) as! EmptyData
        }
    }
}

class EmptyData: NSObject {
    var name: String = ""
}

