//
//  ColorLog.swift
//  SwiftWB
//
//  Created by luozhijun on 16/8/29.
//  Copyright © 2016年 luozhijun. All rights reserved.
//

import UIKit

//MARK: - 自定义log
/**
 调试打印
 - note 需要在`Other Swift Flags`中的Debug栏中添加`-D`和`DEBUG`, 同时别忘了添加`${inherited}`
 */
func debugLog(items: Any..., file: String = #file, line: Int = #line) {
//    #if DEBUG
        let shortCutFileName = (file as NSString).lastPathComponent
        let printingString = ">>[\(shortCutFileName)]--[line:\(line)]👇:"
        print(printingString)
        // 如果直接print(items), 打印出来的东西会在最外层带有一对"[]"
        for item in items {
            print(item)
        }
//    #endif
}

/**
 打印类型转换失败时的警告信息, 只会在DEBUG模式下执行
 
 - parameter convertingObject: 被转换的对象
 - parameter toType:           转换成何种类型
 */
func typeConvertError(convertingObj convertingObj: Any, toType: Any, file: String = #file, line: Int = #line) {
    
//    #if DEBUG
    // Think Out 只需要打印对象类型的地址即可, 如果是非引用类型, 传入函数后会被拷贝, 即使打印地址, 也是被拷贝后的地址, 无意义
    var addressString: String? = nil
    
    // warning 实践中发现AnyObjcet相当于NSObjcet, 如果是Swfit本地的Class(不继承NSObjcet), 虽然它也是引用类型
    // 所以, 更严谨的方法是下面的方式判断到底convertingObj是值类型还是引用类型, 注意到值类型在赋值的时候必然发生深拷贝
    if isRefrenceType(convertingObj) {
        let temp = convertingObj as! AnyObject
        addressString = addressOfHeapVariable(temp)
    }
    
    if addressString != nil {
        debugLog("error: cannot convert `\(convertingObj)<\(addressString!)>`('\(convertingObj.dynamicType)') to type '\(toType)'", file: file, line: line)
    } else {
        debugLog("error: cannot convert `\(convertingObj)`('\(convertingObj.dynamicType)') to type '\(toType)'", file: file, line: line)
    }
//    #endif
}

/**
 判断一个变量是引用类型还是值类型, 注意到值类型在赋值的时候必然发生深拷贝
 - note 但经实践, 发现使用unsafeAddressOf获取到的Int, Double类型的内存地址不正确, 目前还未找到判断obj到底是AnyObjcet还是纯swift类型(比如Double)
 */
func isRefrenceType(obj: Any) -> Bool {
    //    if obj.dynamicType  {
        let temp1 = obj as? AnyObject
        let temp2 = obj as? AnyObject
        if temp1 != nil && temp2 != nil {
            if unsafeAddressOf(temp1!) == unsafeAddressOf(temp2!) {
                return true
            }
        }
        return false
//    }
//    else {
//        let temp1 = obj as? UnsafePointer<Void>
//        let temp2 = obj as? UnsafePointer<Void>
//        if temp1 != nil && temp2 != nil {
//            if addressOfStackVariable(temp1!) == addressOfStackVariable(temp2!) {
//                return true
//            }
//        }
//        return false
//    }
}

/**
 返回一个堆区变量的地址, 适用于对象类型, 或者说引用类型
 */
func addressOfHeapVariable<T: AnyObject>(obj: T) -> String {
    return String(format: "%p", unsafeAddressOf(obj))
}

/**
 返回一个栈区变量的地址, 适用于值类型, 比如Int, Struct
 */
func addressOfStackVariable(pointer: UnsafePointer<Void>) -> String {
    return String(format: "%p", unsafeBitCast(pointer, Int.self))
}

//MARK: - 带颜色输出
struct ColorLog {
    // 决定颜色输出的标识
    static let ESCAPE = "\u{001b}["
    // 决定前景色还是背景色
    static let RESET_FG = ESCAPE + "fg;" // Clear any foreground color
    static let RESET_BG = ESCAPE + "bg;" // Clear any background color
    static let RESET = ESCAPE + ";"   // Clear any foreground or background color
    
    
    static func debugColorLog(colorLog: String, file: String = #file, line: Int = #line) {
        #if DEBUG
            let shortCutFileName = (file as NSString).lastPathComponent
            let locationString = ">>[\(shortCutFileName)]--[line:\(line)]👇:"
//            print("\(ESCAPE)fg230,44,73;\(string)\(RESET)")
            print(locationString)
            print("---" + colorLog + "---")
        #endif
    }
    
    /** 警告输出 */
    static func warn(message: String, file: String = #file, line: Int = #line) {
        debugColorLog("\(ESCAPE)fg186,45,162;\("Warning: " + message)\(RESET)", file: file, line: line)
    }
    
    /** 事件发生提醒 */
    static func eventTriggered(file: String = #file, line: Int = #line, function: String = #function) {
        debugColorLog("\(ESCAPE)fg0,0,255;\(function)\(RESET)", file: file, line: line)
    }
    
    // 红色输出
    static func red(items: Any..., file: String = #file, line: Int = #line) {
        debugColorLog("\(ESCAPE)fg230,44,73;\(items)\(RESET)", file: file, line: line)
    }
    
    // 绿色输出
    static func green(items: Any..., file: String = #file, line: Int = #line) {
        #if DEBUG
            let scanner = NSScanner(string: "0x1f448")
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            let emoji = "\(Character(UnicodeScalar(result)))"
            debugColorLog(emoji+"\(ESCAPE)fg38,173,97;\(items)\(RESET)", file: file, line: line)
        #endif
    }
    
    // 蓝色输出
    static func blue(items: Any..., file: String = #file, line: Int = #line) {
        #if DEBUG
            debugColorLog("\(ESCAPE)fg0,0,255;\(items)\(RESET)", file: file, line: line)
        #endif
    }
    
    //黄色输出
    static func yellow(items: Any..., file: String = #file, line: Int = #line) {
        #if DEBUG
            debugColorLog("\(ESCAPE)fg242,196,15;\(items)\(RESET)", file: file, line: line)
        #endif
    }
    
    //紫色输出
    static func purple(items: Any..., file: String = #file, line: Int = #line) {
        #if DEBUG
            debugColorLog("\(ESCAPE)fg255,0,255;\(items)\(RESET)", file: file, line: line)
        #endif
    }
    
    //青色输出
    static func cyan(items: Any..., file: String = #file, line: Int = #line) {
        #if DEBUG
            debugColorLog("\(ESCAPE)fg0,255,255;\(items)\(RESET)", file: file, line: line)
        #endif
    }
    
    // 打印两个对象分别蓝色和黄色输出
    static func blueAndYellow<T>(obj1: T, obj2: T, file: String = #file, line: Int = #line) {
        #if DEBUG
            debugColorLog("\(ESCAPE)fg0,0,255;\(obj1)\(RESET)" + "\(ESCAPE)fg255,255,0;\(obj2)\(RESET)", file: file, line: line)
        #endif
    }
    
    // 亮蓝色输出
    static func lightBlue(items: Any..., file: String = #file, line: Int = #line) {
        #if DEBUG
            let scanner = NSScanner(string: "0x1f449")
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            let emoji = "\(Character(UnicodeScalar(result)))"
            debugColorLog(emoji+"\(ESCAPE)fg41,128,185;\(items)\(RESET)", file: file, line: line)
        #endif
    }
}
