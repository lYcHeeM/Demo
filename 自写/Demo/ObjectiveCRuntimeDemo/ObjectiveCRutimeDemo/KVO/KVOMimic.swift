////
////  KVOMimic.swift
////  ObjectiveCRutimeDemo
////
////  Created by luozhijun on 2017/3/13.
////  Copyright © 2017年 RickLuo. All rights reserved.
////
//
//import UIKit
//
//typealias KVONotification = (NSObject, String, Any, Any) -> Swift.Void
//
//enum KVOError : Error {
//    case setterNotFound
//}
//
//let KVOClassPrefix = "ZJKVOClassPrefix_"
//
//extension NSObject {
//    
//    func zj_addObserver(_ observer: NSObject, forKeyPath keyPath: String, changed: KVONotification) throws {
//        guard !keyPath.isEmpty else {
//            return
//        }
//        
//        // 获取setter指针
//        let setterSelector   = NSSelectorFromString(setterString(forKey: keyPath))
//        let tempSetterMethod = class_getInstanceMethod(self.classForCoder, setterSelector)
//        guard let setterMethod = tempSetterMethod else {
//            throw KVOError.setterNotFound
//        }
//        
//        // 判断当前类是否已经加入监听列表中
//        var selfClass = object_getClass(self)!
//        let selfClassName = NSStringFromClass(selfClass)
//        
//        // 如果没有正在被监听, 则生成临时类, 并把当前类的isa指向这个临时类
//        if !selfClassName.hasPrefix(KVOClassPrefix) {
//            selfClass = kvoClass(forOriginalClass: selfClassName)
//            object_setClass(self, selfClass)
//        }
//        
//        // 判断当前类(已把isa指向临时类)是否已有"key"属性的setter, 如果没有, 生成一个
//        if !has(selector: setterSelector) {
////            let typeEncoding = method_getTypeEncoding(setterMethod)
////            let kvoSetter: @convention(block) (NSObject, Selector, Any) -> Swift.Void = { (self, _cmd, newValue) in
////                let setterName = NSStringFromSelector(_cmd)
////                guard let getterName = self.getterString(forSetterString: setterName) else {
////                    fatalError("Object \(self) does not have setter \(setterName).")
////                }
////                let oldValue = self.value(forKey: getterName)
////                let superObject = class_getSuperclass(object_getClass(self))!
////            }
//        }
//        
//    }
//    
//    func zj_removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
//        
//    }
//}
//
//
////MARK: - Helpers
//extension NSObject {
//    fileprivate func setterString(forKey key: String) -> String {
//        let firstLetter = key.substring(to: key.startIndex).uppercased()
//        let remainningLetters = key.substring(from: key.index(after: key.startIndex))
//        
//        return "set\(firstLetter)\(remainningLetters)"
//    }
//    
//    fileprivate func getterString(forSetterString setter: String) -> String? {
//        guard !setter.isEmpty, setter.hasPrefix("set"), setter.hasSuffix(":") else {
//            return nil
//        }
//        
//        // 去掉"set:"
//        let result = setter.substring(from: setter.index(setter.startIndex, offsetBy: 4))
//        return result.lowercased()
//    }
//    
//    fileprivate func has(selector: Selector) -> Bool {
//        let selfClass = object_getClass(self)
//        var methodCount: UInt32 = 0
//        guard let methodList = class_copyMethodList(selfClass, &methodCount) else {
//            return false
//        }
//        let methodCountInt = Int(methodCount)
//        for index in 0..<methodCountInt {
//            let thisSelector = method_getName(methodList[index])
//            if thisSelector == selector {
//                free(methodList)
//                return true
//            }
//        }
//        free(methodList)
//        return false
//    }
//    
//    fileprivate func kvoClass(forOriginalClass className: String) -> AnyClass {
//        let kvoClassName = KVOClassPrefix + className
//        var kvoClass = NSClassFromString(kvoClassName)
//        
//        // 如果之前对相同类的实例添加过观察, 并且尚未移除观察, 则class应该存在, 不需重建
//        if kvoClass != nil {
//            return kvoClass!
//        }
//        
//        // 运行时生成新类, 并令其继承自self(被监听的类)
//        let originalClass = object_getClass(self)!
//        kvoClass = objc_allocateClassPair(originalClass, (kvoClassName as NSString).utf8String, 0)
//        
//        // 重写classForCoder方法, 使得kvo对使用者来说透明化
//        let classMethod = class_getInstanceMethod(originalClass, #selector(getter: classForCoder))!
//        let typeEncoding = method_getTypeEncoding(classMethod)!
//        class_addMethod(kvoClass, #selector(getter: classForCoder), imp_implementationWithBlock({
//            return class_getSuperclass(originalClass)
//        }), typeEncoding)
//        
//        objc_registerClassPair(kvoClass)
//        
//        return kvoClass!
//    }
//
//}
