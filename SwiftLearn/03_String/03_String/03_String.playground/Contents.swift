print("Hello, World!")

// 字符串是value类型, 使用时编译器会拷贝一份新值

// 连接字符串
var mutableString = "0123456789\(1)"
//mutableString.appendContentsOf("23")
mutableString += "23"
mutableString.append(Character("#"))

// 打印每个字符
for char in mutableString.characters {
    print(char)
}
print()

// 用仅含单个字符的字符串初始化一个Character类型的变量
var exclamationMark: Character = "!"
print(exclamationMark)

// -------------------
// 字符串初始化
    // empty string
let emptyString1 = ""
let emptyString2 = String()
var nilString: String?
if emptyString1.isEmpty && emptyString2.isEmpty {
    print("YES")
}

    // 以字符数组初始化
let catCharacters: [Character] = ["C", "a", "t", "🐱"];
var catString = String(catCharacters)
print(catString)

var standAloneChar: Character = "a"

let pi = 3.14
let stringInterprolation = "Pi is \(pi), at the left of the decimal is \(Int(pi))"
print(stringInterprolation)

// ---------------------------------------
// Unicode extented grapheme clusters
let dollarSign = "\u{24}"
let sparklingHeart = "\u{1F496}"

let eAcute = "\u{E9}"
let combinedEAcute = "\u{65}\u{301}"
var eAcuteCharactersCount = eAcute.characters.count
eAcuteCharactersCount = combinedEAcute.characters.count

var hangul = "\u{1112}"
hangul += "\u{1161}"
hangul += "\u{11AB}"
let hangulLength = hangul.characters.count

// ---------------------------------------
// Access and modify string
var stringIndex: String.Index?

let theShy = "The Shy!#@\u{65}\u{301}"
theShy[theShy.startIndex]
theShy[theShy.endIndex.predecessor()]
// runtime error
//theShy[theShy.startIndex.predecessor()]
//theShy[theShy.endIndex]

let theShyLenght = theShy.characters.count
for index in theShy.characters.indices {
    print(index)
}

// ---------------------------------------
// Compare
let compareStr1 = "caf\u{E9}"
let compareStr2 = "cafe\u{301}"
if compareStr1 == compareStr2 {
    print("equal")
}

let latinA = "A"
let cyrillcA = "\u{0410}"
if latinA != cyrillcA {
    print("not euqal")
}



