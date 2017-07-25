//: Playground - noun: a place where people can play

import UIKit

// nil在swift中是一种特殊类型, 和OC中的空(零)指针不同
// 而swift是强类型语言, 所以不可以直接给一般的类型置nil
// var name : String = nil 会报编译错误


//MARK: - 声明一个可选类型

// Optional是泛型
var name: Optional<String> = nil
// 常用方式
var name1: String? = nil


//MARK: - 解包
// 解开可选类型的包装

name1 = "Faker"
// 打印发现name1的值为Optional("Faker"), 并不是"Faker"
print(name1)

// Force Unwrapping, 强制解包, 但很可能造成运行时错误
// 比如name1为nil时, 如果强制解包则导致crash
print(name1!)

// 故可加上判断
if name1 != nil {
    print(name1!)
}

//MARK: - 可选绑定
// 虽然每次解包可选对象时, 都可通过判断是否为nil再进行解包, 但这样在使用时总是要带上叹号, 不方便, 故有"可选绑定"改良

// 个人也有一个疑问, swift规定if后的判断必须返回Bool, 而swift中赋值表达式是没有返回值的, 所以可能这是swift中if判断条件的特例
if let tempName = name1 {
    print(tempName)
}

// 更常用的写法, 利用多数编程语言中的标识符就近原则
if let name1 = name1 {
    print(name1)
}

