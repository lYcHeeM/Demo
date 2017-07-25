//: Playground - noun: a place where people can play

import UIKit

var str = "Swift Fuction"

// ---------------------------------------
// default parameter values
func someFunction1(param1: Bool, paramWithDefault: Int = 5, paramWithoutDefault: String) {
    
}
someFunction1(true, paramWithoutDefault: "2")
someFunction1(true, paramWithDefault: 10, paramWithoutDefault: "3")

func someFunction2(param1: Bool, paramWithoutDefault: String, paramWithDefault: Int = 5) {
    
}
someFunction2(true, paramWithoutDefault: "2")
someFunction2(true, paramWithoutDefault: "3", paramWithDefault: 10)
// 总结: 尽量把需要设立默认值的参数放到参数表末尾, 使得所有不含默认值的参数在多次调用时顺序保持一致, 增强代码可读性.

// ---------------------------------------
// variadic parameter
func arithmeticMean(numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}

arithmeticMean(1, 2, 3, 4, 5, 6, 7, 8, 9, 10.0)

// A function may have at most one varicadic parameter
//func errorSyntax(numbers: Double..., strings: String...) { }

// ---------------------------------------
// In-out parameters
func swapTwoInts1(inout a anInt: Int, inout b anotherInt: Int) {
    let temp = anInt
    anInt = anotherInt
    anotherInt = temp
}

var a = 10
var b = 20
swapTwoInts1(a: &a, b: &b)
print("a: \(a), b: \(b)")

func swapTwoInts2(inout a: Int, inout _ b: Int) {
    let temp = a
    a = b
    b = temp
}
swapTwoInts2(&a, &b)
print("a: \(a), b: \(b)")

// 不论external parameter和local parameter是否同名, 不影响对实参的操作

// ---------------------------------------
// Function Types
func addTwoInts(a: Int, _ b: Int) ->Int {
    return a + b
}
func multiplyTwoInts(a: Int, _ b: Int) ->Int {
    return a * b
}

var mathFunction: (Int, Int) -> Int = addTwoInts
mathFunction = multiplyTwoInts
print("\(mathFunction(10, 20))")

// as fuction parameter
func printMathResult(mathFunc funcRef: (Int, Int) -> Int, a: Int, b: Int) {
    print("Result: \(funcRef(a, b))")
}

printMathResult(mathFunc: addTwoInts, a: 10, b: 20)
printMathResult(mathFunc: mathFunction, a: 10, b: 20)

// as return types
func stepForward(inout input: Int) {
    input += 1
}
func stepBackword(inout input: Int) {
    input -= 1
}

typealias stepFunctionType = (inout Int) -> Void

func chooseSetpFuction(shouldBackwords backwords: Bool) -> stepFunctionType {
    return backwords ? stepBackword : stepForward
}

var currentValue = 5
repeat {
    let moveNearerToZero = chooseSetpFuction(shouldBackwords: currentValue > 0)
    moveNearerToZero(&currentValue)
    print("\(currentValue)...")
} while currentValue != 0

// ---------------------------------------
// Nested Functions
