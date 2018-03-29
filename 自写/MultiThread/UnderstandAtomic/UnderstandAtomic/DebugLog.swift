//
//  DebugLog.swift
//  UnderstandAtomic
//
//  Created by luozhijun on 2018/3/27.
//  Copyright © 2018年 luozhijun. All rights reserved.
//

import Foundation

//MARK: - 自定义log
/**
 调试打印
 - note 需要在`Other Swift Flags`中的Debug栏中添加`-D`和`DEBUG`, 同时别忘了添加`${inherited}`
 */
func debugLog(_ items: Any?..., file: String = #file, line: Int = #line) {
    #if DEBUG
        let shortcutFileName = (file as NSString).lastPathComponent
        let printingString = ">>[\(shortcutFileName)]--[line:\(line)]👉🏻: "
        print(printingString, separator: " ", terminator: "")
        // 如果直接print(items), 打印出来的东西会在最外层带有一对"[]"
        for item in items {
            if item != nil {
                print(item!)
            } else {
                print("nil")
            }
        }
    #endif
}

private let objc_sync_ref: Int = 0

/// 奇怪，发现用下面这个对象当作同步锁的参照，不起作用，难道是地址会变，Swift中Int和String同样是Struct类型，都可能会发生拷贝啊。
//private let objc_sync_ref_string: String = "objc_sync_ref_string"

/// 发现确实是值类型引起的错误，当下面的class改成struct后，会使得debugLogSync中的同步锁失效，极有可能是objc_sync_enter()函数会对值类型的参数拷贝，但上面的Int类型的objc_sync_ref不存在这个问题，估计是Int类型的变量即使被拷贝了，但objc_sync_enter()函数所依赖的参照没有变。
private class __Temp_objc_sync {}
private let objc_sync_ref_object = __Temp_objc_sync()

//MARK: - 自定义log
/**
 调试打印
 - note 需要在`Other Swift Flags`中的Debug栏中添加`-D`和`DEBUG`, 同时别忘了添加`${inherited}`
 */
func debugLogSync(_ items: Any?..., file: String = #file, line: Int = #line) {
    #if DEBUG
        objc_sync_enter(objc_sync_ref_object)
        let shortcutFileName = (file as NSString).lastPathComponent
        let printingString = ">>[\(shortcutFileName)]--[line:\(line)]👉🏻: "
        print(printingString, separator: " ", terminator: "")
        // 如果直接print(items), 打印出来的东西会在最外层带有一对"[]"
        for item in items {
            if item != nil {
                print(item!)
            } else {
                print("nil")
            }
        }
        objc_sync_exit(objc_sync_ref_object)
    #endif
}
