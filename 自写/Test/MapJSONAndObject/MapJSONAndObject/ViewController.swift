//
//  ViewController.swift
//  MapJSONAndObject
//
//  Created by luozhijun on 2016/10/19.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonFilePath = NSBundle.mainBundle().pathForResource("data", ofType: ".json")!
        let jsonData = NSData(contentsOfFile: jsonFilePath)
        if let jsonData = jsonData {
            if let jsonObj = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? [String: AnyObject] {
                if let jsonObj = jsonObj {
                    print(jsonObj)
//                    let model = FirstLevelModel(dict: jsonObj)
//                    print(model)
                }
            }
        }
        
        var aaa = [String: String]()
        aaa.updateValue(<#T##value: Value##Value#>, forKey: <#T##Hashable#>)
        let baseModel = KVCBaseModel(dict: ["aaa": "aaa"])
        print(baseModel.propertyNames)
//        print(baseModel.dictionaryValue)
//        let array = ClinicModel.modelArrayWith(dictionaryArray: [["aaa": "aaa"], ["aaa": "aaa"]])
//        print(array)
        
//        let model = ClinicModel()
//        print(model)
//        print(model.dictionaryValue)
//        var outCount = UInt32()
//        let properties: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(ClinicModel.self, &outCount)
//        var propertyNames = [String]()
//        let intCount = Int(outCount)
//        for i in 0 ..< intCount {
//            let property : objc_property_t = properties[i]
//            guard let propertyName = NSString(UTF8String: property_getName(property)) as? String else {
//                debugPrint("Couldn't unwrap property name for \(property)")
//                break
//            }
//            propertyNames.append(propertyName)
//        }
//        print(propertyNames)
        
        print(PAClinicSearchingParam().dictionaryValue)
    }

}

class PAClinicSearchingParam: KVCBaseModel {
    var app_code: String = "12012"
    var doctorId: String = "撒大法师发送到"
    var clinicName: String = "dsafasd"
    var pageNo: Int = 1
    var pageSize: Int = 20
}
//
//
////typealias JSONDictionary = [String: AnyObject]
//class ClinicModel : KVCBaseModel {
//    var bbb: String?
//}
//
///** 使用KVC把JSON字典转为模型, 并且使用反射把模型转成字典 */
//class KVCBaseModel : NSObject {
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
//    
//    override init() {
//        super.init()
//    }
//    
//    required init(dict: JSONDictionary?) {
//        super.init()
//        if let dict = dict {
//            setValuesForKeysWithDictionary(dict)
//        }
//    }
//    
//    convenience init?(object: AnyObject?) {
//        if let dict = object as? JSONDictionary {
//            self.init(dict: dict)
//        } else {
//            return nil
//        }
//    }
//    
//    class func modelArrayWith(dictionaryArray dictionaryArray: [JSONDictionary]) -> [KVCBaseModel]? {
//        var modelArray = [KVCBaseModel]()
//        for dict in dictionaryArray {
//            let model = self.init(dict: dict)
//            modelArray.append(model)
//        }
//        if modelArray.count > 0 {
//            return modelArray
//        }
//        return nil
//    }
//    
//    /// 属性名称, 包含从父类继承的属性, 不包括NSObject的属性
//    var propertyNames: [String]? {
//        var class_temp: AnyClass? = self.classForCoder
//        var names = [String]()
//        
//        while NSStringFromClass(class_temp!) != NSStringFromClass(NSObject.self) {
//            for child in Mirror(reflecting: (class_temp as! KVCBaseModel.Type).init(dict: nil)).children {
//                if let name = child.label {
//                    names.append(name)
//                }
//            }
//            class_temp = class_getSuperclass(class_temp)
//        }
//        
//        if names.count > 0 {
//            return names
//        }
//        return nil
//    }
//    
//    /// 属性名和属性值构成的字典, 包含从父类继承的属性, 不包括NSObject的属性
//    var dictionaryValue: [String: AnyObject]? {
//        guard let propertyNames = propertyNames else {
//            return nil
//        }
//        return dictionaryWithValuesForKeys(propertyNames)
//    }
//}