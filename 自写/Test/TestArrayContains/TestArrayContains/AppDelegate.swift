//
//  AppDelegate.swift
//  TestArrayContains
//
//  Created by luozhijun on 2016/10/25.
//  Copyright © 2016年 RickLuo. All rights reserved.
//

import UIKit

class MyComparable1: Equatable {
    public static func ==(lhs: MyComparable1, rhs: MyComparable1) -> Bool {
        return lhs === rhs
    }
}

class MyComparable2 {
    
}

class MyComparable3: NSObject {
    override func isEqual(_ object: Any?) -> Bool {
        return true
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Objc
        let person = Person()
        person.testContains()
        
        // Swift
        let obj1 = UIView()
        let array: [Any] = [NSObject(), "2016-12-12", obj1]
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd"
        let str = formater.string(from: Date())
        
        // true Swfit 3.x
        let contains1 = array.contains { (element) -> Bool in
            guard let element = element as? String else { return false }
            if element == str {
                return true
            } else {
                return false
            }
        }
        // Swift 2.x
//        let contains1 = array.contains(str)

        let obj2 = UIView()
        // false
        let contains2 = array.contains { (element) -> Bool in
            guard let element = element as? UIView else {return false}
            if element == obj2 {
                return true
            } else {
                return false
            }
        }
        
        print(contains1, contains2)
        // 经过上面两段测试, 证明不论是Objc还是Swift, 数组中对字符串比较都是值的比较, 虽然Objc中的NSString是对象类型, 最可能的是NSString内部重写了isEqual方法, 实现值的比较, 而默认的isEqual应该是比较指针的值
        // 通过testContains()方法中的打印可知
        // 另外发现用子类继承NSString, 重写isEqual居然无效
        
        
        let array2: [MyComparable1] = [MyComparable1(), MyComparable1()]
        let obj3 = MyComparable1()
        let contrains3 = array2.contains(obj3)
        
        let array3: [MyComparable2] = [MyComparable2(), MyComparable2()]
        let obj4 = MyComparable2()
        // 发现一个纯Swift class, 如果没有遵循Equatable协议, 无法使用非闭包参数的contains方法
        let contains4 = array3.contains { $0 === obj4 }
        
        let array4 = [MyComparable3(), MyComparable3()]
        let obj5 = MyComparable3()
        let contains5 = array4.contains(obj5)
        
        print(contrains3, contains4, contains5)
        
        var string1 = "aaa"
        var string2 = "aaa"
        var string3 = "bbb"
        var int1 = 10
        var int2 = int1
        var object1 = MyComparable2()
        var object2 = object1
        print(address(of: &string1))
        print(address(of: &string2))
        print(address(of: object1))
        print(address(of: object2))
        withUnsafePointer(to: &object1) {
            print($0)
        }
        withUnsafePointer(to: &object2) {
            print($0)
        }
        print(string1._core._baseAddress!)
        print(string2._core._baseAddress!)
        
        return true
    }

}

func address(of stackVariable: UnsafeRawPointer) -> String {
    return String(format: "%p", unsafeBitCast(stackVariable, to: Int.self))
}

func address(of object: AnyObject) -> String {
    return String(format: "%p", unsafeBitCast(object, to: Int.self))
}

