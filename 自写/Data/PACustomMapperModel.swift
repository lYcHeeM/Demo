//
//  PACustomMapperModel.swift
//  wanjia2B
//
//  Created by luozhijun on 2017/5/15.
//  Copyright © 2017年 pingan. All rights reserved.
//

import UIKit

/** 
 解决服务端返回字段映射问题, 比如把服务端的clinic_name字段名映射为本地的clinicName.
 虽然YYModel提供了此功能, 但经多次测试发现, 此功能偶尔会失效, 为了不侵入YYModel源代码, 此处使用KVC代替之.
 - note 因为KVC对属性的类型很敏感, 比如把Number类型写成了String, 会导致奔溃(反之亦然), 故在定义模型时须注意和实际JSON中的字段类型一一对应.
 */
class PACustomMapperModel: NSObject {
    
    /// 需要映射的字段.
    /// 格式: ["clinicName": "clinic_name"], key是目标字段名, value是服务端返回JSON中的原始字段名.
    func customPropertyMapper() -> [String : String]? {
        return nil
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    override init() {
        super.init()
    }
    
    required init(dict: [String: Any]) {
        super.init()
        if let mapper = self.customPropertyMapper() {
            var usingDict = [String: Any]()
            for (key, value) in dict {
                var mapped = false
                mapper.forEach {
                    if $0.value == key {
                        usingDict.updateValue(value, forKey: $0.key)
                        mapped = true
                    }
                }
                if !mapped { usingDict.updateValue(value, forKey: key) }
            }
            setValuesForKeys(usingDict)
        } else {
            setValuesForKeys(dict)
        }
    }
    
    class func instances<T: PACustomMapperModel>(with dicts: [[String: Any]]) -> [T] {
        var results = [T]()
        dicts.forEach { results.append(T(dict: $0)) }
        return results
    }
}


