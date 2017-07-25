//: Playground - noun: a place where people can play

import UIKit

//MARK: - 内部参数\外部参数

// “Each function parameter has both an argument label and a parameter name. The argument label is used when calling the function; each argument is written in the function call with its argument label before it. The parameter name is used in the implementation of the function. By default, parameters use their parameter name as their argument label.”

// 摘录来自: Apple Inc. “The Swift Programming Language (Swift 3 Beta)”。 iBooks. https://itun.es/us/k5SW7.l

func sum(num1: Int, num2: Int) -> Int {
    return num1 + num2
}
sum(10, num2: 20)
// 发现在调用函数时第一个参数的名称会被省略

// 内部参数: 在函数内部可见的参数就是内部参数, 默认情况下所有参数都是内部参数
// 外部参数: 在函数外部可见的参数就是外部参数, 从第二个参数开始, 既是内部参数也是外部参数
// 如果想令第一个参数也为外部参数, 从而可在调用时显示参数名, 可在它的标识符前面加上别名
func sum(num1 num1: Int, num2: Int, num3: Int) -> Int {
    return num1 + num2 + num3
}
sum(num1: 10, num2: 20, num3: 30)

// 省略参数标识 Omitting argument label
// 在参数名称前面加上一个下划线
func someFunc(argu1: Int, _ argu2: String) {
    print("someFunc")
}
someFunc(10, "")


//MARK: - 默认参数
// swift和OC不同, 支持函数重载和默认参数
// 默认"制作雀巢咖啡"
func makeCoffee(coffeeName: String = "雀巢") -> String {
    return "制作了一杯\(coffeeName)"
}

makeCoffee("拿铁")
makeCoffee("卡布奇诺")
makeCoffee()


//MARK: - 可变参数

// option+鼠标左键点击num可看出num是[Int]类型
func sum(num: Int...) -> Int {
    var result = 0
    for n in num {
        result += n
    }
    return result
}
sum(10, 20, 30, 40, 50)


//MARK: - 读写参数 In-Out

// 类似此c++中的引用传递
var m = 10
var n = 20
func swap(inout num1: Int, inout num2: Int) {
    let temp = num1
    num1 = num2
    num2 = temp
}
swap(&m, num2: &n)
m
n


//MARK: - 函数嵌套

func nestedFunc() {
    func test() {
        print("test")
    }
    print("nestedFunc")
    test()
}

nestedFunc()
// 虽然swift支持函数嵌套, 但为了提高代码可读性, 尽量少用




