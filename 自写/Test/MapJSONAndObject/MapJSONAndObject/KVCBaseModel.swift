//
//  KVCBaseModel.swift
//  MapJSONAndObject
//
//  Created by luozhijun on 2016/11/4.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

/** 使用KVC把JSON字典转为模型, 并且使用反射把模型转成字典 */
class KVCBaseModel : NSObject {
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override init() {
        super.init()
    }
    
    required init(dict: JSONDictionary?) {
        super.init()
        if let dict = dict {
            setValuesForKeysWithDictionary(dict)
        }
    }
    
    convenience init?(object: AnyObject?) {
        if let dict = object as? JSONDictionary {
            self.init(dict: dict)
        } else {
            return nil
        }
    }
    
    class func modelArrayWith(dictionaryArray dictionaryArray: [JSONDictionary]) -> [KVCBaseModel]? {
        var modelArray = [KVCBaseModel]()
        for dict in dictionaryArray {
            let model = self.init(dict: dict)
            modelArray.append(model)
        }
        if modelArray.count > 0 {
            return modelArray
        }
        return nil
    }
    
    /// 存储属性的名称, 包含从父类继承的属性, 不包括NSObject的属性
    var propertyNames: [String]? {
        var class_temp: AnyClass? = self.classForCoder
        var names = [String]()
        
        while NSStringFromClass(class_temp!) != NSStringFromClass(NSObject.self) {
            for child in Mirror(reflecting: (class_temp as! KVCBaseModel.Type).init(dict: nil)).children {
                if let name = child.label {
                    names.append(name)
                }
            }
            class_temp = class_getSuperclass(class_temp)
        }
        
        if names.count > 0 {
            return names
        }
        return nil
    }
    
    /// 存储属性名称和值构成的字典, 包含从父类继承的属性, 不包括NSObject的属性
    var dictionaryValue: [String: AnyObject]? {
        guard let propertyNames = propertyNames else {
            return nil
        }
        return dictionaryWithValuesForKeys(propertyNames)
    }
}
