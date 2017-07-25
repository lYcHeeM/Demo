//: Playground - noun: a place where people can play

import UIKit

// swift中的错误类型必须遵循ErrorType协议
// swift3.0似乎是Error协议
enum WeChatError: ErrorType {
    case NoNetwork
    case NoStreamData
    case NoPower
}

func playWeChat(hasNetwork: Bool, hasStreamData: Bool, hasPower: Bool) throws -> String {
    guard hasNetwork else {
        throw WeChatError.NoNetwork
    }
    
    guard hasStreamData else {
        throw WeChatError.NoStreamData
    }
    
    guard hasPower else {
        throw WeChatError.NoPower
    }
    
    return "可以玩微信了"
}

// 一般的处理异常流程 do try catch
do {
    let info = try playWeChat(true, hasStreamData: false, hasPower: true)
    print(info)
}
catch WeChatError.NoNetwork {
    print("没网怎么玩")
} catch WeChatError.NoStreamData {
    print("超流量可是要花很多钱的啊")
} catch WeChatError.NoPower {
    print("没电还是洗洗睡吧")
}

// try! 如果有异常, 则导致程序crash, 否则返回指定类型的值
let info1 = try! playWeChat(true, hasStreamData: true, hasPower: true)

// try? 如果有异常, 整个表达式返回nil, 否则放回指定类型的Optional值
// 如果返回类型是String?, 则真个表达式返回的是Optional<Optional<String>>(或者说String??)类型, 即又包装了一次
let info2 = try? playWeChat(true, hasStreamData: false, hasPower: false)

let jsonString = "[{\"user\":{\"name\": \"Google\", \"url\": \"http://www.google.com\"}},{\"user\":{\"name\": \"Baidu\",\"url\": \"http://www.baidu.com\"}}]"
let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
let jsonObj = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]]
// option + 鼠标左键发现jsonObj是[[String: Anyobject]]??类型, 因为"as? [[String: AnyObject]]"把返回值类型指定为了[[String: AnyObject]]?类型, 在加上try?对整个表达式包装了一层optional, 所以jsonObj为[[String: Anyobject]]??类型
if let jsonObj = jsonObj {
    let user = jsonObj?[0]["user"] as? [String: AnyObject]
    let name = user?["name"]
    
    if let jsonObj = jsonObj {
        // 只有来到这里, jsonObj才是[[String: AnyObjcet]]类型
        let user = jsonObj[0]["user"] as? [String: AnyObject]
        let name = user?["name"]
    }
}

// optional chaining 写法
if let jsonObj = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]], let user = jsonObj?[0]["user"] as? [String: AnyObject] {
    let name = user["name"]
}

// 发现居然如果jsonString随便指定一个比如"aaa", 下面的代码居然不会引发crash, 而是不执行, 连pirnt(jsonObj1)也不执行
// 后来才知道在playground可以这么写, 但是在工程文件中就不行, try之后必须处理异常
let jsonObj1 = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]]
print(jsonObj1)
if let jsonObj = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]], let user = jsonObj[0]["user"] {
    
}






