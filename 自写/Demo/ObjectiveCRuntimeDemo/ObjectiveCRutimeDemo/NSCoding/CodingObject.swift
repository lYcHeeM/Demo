//
//  NSObject+NSCoding.swift
//  NSCodingRumtimeImplementation
//
//  Created by luozhijun on 2016/12/23.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

/**
 *  功能:
 *      如果某个自定义对象需要支持归档, 继承此对象可省去手写init?(coder aDecoder: NSCoder)方法和encode(with aCoder: NSCoder)方法中的所有冗余代码。
 *
 *  使用方法:
 *      需要归解档的对象, 继承"CodingObject"即可
 *
 *  - note:
 *      如果需要归档的对象"有自定义子对象"或"集合类型的属性"时, 自定义对象和集合中的对象也需遵循NSCoding协议, 比如Array, 当Array作为encodeObject:ForKey:方法中的参数时, 实际上是作用于其内部所有对象.
 */
class CodingObject: NSObject, NSCoding {
    
    /// "存储属性"的名称, 包含从父类继承的属性, 不包括NSObject基类的属性
    var propertyNames: [String]? {
        var selfClass: AnyClass? = self.classForCoder
        var names = [String]()
        
        while selfClass != nil {
            guard let NSObjectClass = selfClass as? NSObject.Type else { return nil }
            Mirror(reflecting: NSObjectClass.init()).children.forEach {
                if let name = $0.label { names.append(name) }
            }
            selfClass = class_getSuperclass(selfClass)
        }
        
        if names.count > 0 { return names }
        return nil
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        encodeOrDecode(with: nil, or: aDecoder)
    }
    
    func encode(with aCoder: NSCoder) {
        encodeOrDecode(with: aCoder, or: nil)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    override func value(forUndefinedKey key: String) -> Any? { return nil }
    
    private func encodeOrDecode(with encoder: NSCoder?, or decoder: NSCoder?) {
        guard let propertyNames = propertyNames else { return }
        propertyNames.forEach {
            encoder?.encode(value(forKey: $0), forKey: $0)
            if let decodedValue = decoder?.decodeObject(forKey: $0) {
                setValue(decodedValue, forKey: $0)
            }
        }
    }
}
