////
////  Models.swift
////  MapJSONAndObject
////
////  Created by luozhijun on 2016/10/19.
////  Copyright © 2016年 RickLuo. All rights reserved.
////
//
//import UIKit
//
///**
// *  "name": "BeJson",
// "url": "http://www.bejson.com",
// "page": 88,
// "isNonProfit": true,
// "address": {
// "street": "科技园路.",
// "city": "江苏苏a州",
// "country": "中国"
// },
// "links": [
// {
// "name": "Google",
// "url": "http://www.google.com"
// },
// {
// "name": "Baidu",
// "url": "http://www.baidu.com"
// },
// {
// "name": "SoSo",
// "url": "http://www.SoSo.com"
// }
// ]
// */
//
//typealias JSONDictionary = [String: AnyObject]
//
//class BaseModel : NSObject {
//    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
//    
//    init(dict: JSONDictionary) {
//        super.init()
//        setValuesForKeysWithDictionary(dict)
//    }
//    
//    convenience init?(object: AnyObject?) {
//        if let dict = object as? JSONDictionary {
//            self.init(dict: dict)
//        } else {
//            return nil
//        }
//    }
//}
//
//class FirstLevelModel : BaseModel {
//    var name: String?
//    var url: String?
//    var page: Int?
//    var isNonProfit: Bool?
//    var address: SecondLevelModel? {
//        didSet {
//            address = SecondLevelModel(object: address)
//        }
//    }
//    var links: NSArray? {
//        didSet {
//            var array = [UrlModel]()
//            print(links)
//            if let links = links {
//                for item in links {
//                    if let element = UrlModel(object: item) {
//                        array.append(element)
//                    }
//                }
//            }
//            if array.count > 0 {
//                links = array as NSArray
//            } else {
//                links = nil
//            }
//        }
//    }
//}
//
//class SecondLevelModel : BaseModel {
//    var street: String?
//    var city: String?
//    var country: String?
//}
//
//class UrlModel : BaseModel {
//    var name: String?
//    var url: String?
//}
//
