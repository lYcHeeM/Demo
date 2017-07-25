//: Playground - noun: a place where people can play

import UIKit

let range: Range<UInt> = 0..<5

print(range)
print(range.lowerBound)
print(range.upperBound)

let str = "aaaaaaaaaa"
let substr = str.substring(with: str.startIndex..<str.index(str.startIndex, offsetBy: 2))
print(substr)

let range1 = ClosedRange<String.Index>(uncheckedBounds:(lower: str.startIndex, upper: str.index(str.startIndex, offsetBy: 3)))
print(range1)

let range2 = ClosedRange<UInt>(uncheckedBounds: (lower: 0, upper: 10))
print(range2)

let substr2 = str.substring(with: str.index(str.startIndex, offsetBy: Int(range.lowerBound))..<str.index(str.startIndex, offsetBy: Int(range.upperBound)))
print(substr2)


/*-------------------------------*/
// 普通可变指针
func test(pointer: UnsafeMutablePointer<Bool>) {
    pointer.pointee = true
}
var bool = false
test(pointer: &bool)
print(bool)

// 指向数组的指针
func test1(pointer: UnsafeMutableBufferPointer<Bool>) {
    for index in 0..<pointer.endIndex {
        pointer[index] = true
    }
}
var bools = [false, false, false]
let ptr = UnsafeMutableBufferPointer<Bool>(start: &bools, count: bools.count)
test1(pointer: ptr)
print(bools)

// 用可变指针操作数据
var int = 10
withUnsafeMutablePointer(to: &int) { (pointer) -> Int in
    pointer.pointee += 1
    return pointer.pointee
}
print(int)

// 不安全类型转换
var int1 = 20
    // 得到指针, 并转为void类型指针
let ptrVoid = withUnsafePointer(to: &int1) { (ptr) -> UnsafePointer<Void> in
    return unsafeBitCast(ptr, to: UnsafePointer<Void>.self)
}
    // 再转回Int类型的指针
let ptrInt = unsafeBitCast(ptrVoid, to: UnsafePointer<Int>.self)
print(ptrInt.pointee)

let arr = NSArray(object: "aaa")
let str3 = unsafeBitCast(CFArrayGetValueAtIndex(arr, 0), to: CFString.self)
print(str3)


let a = Optional<Int>(10)
let b = Optional<Int>.some(10)
let c = Optional<Int>.none



