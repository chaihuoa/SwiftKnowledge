//: [Previous](@previous)

import Foundation

var word = "In simple terms, if the closure will be called after the function returns, we’ll need to add the @escaping keyword. "
let array = word.components(separatedBy: "closure")
array.reduce("") { partialResult, str in
    return partialResult + str
}

var greeting = "Bilibili"
var books = "📚 Books"
let arr = [greeting, "🏫 Studies", books, "Blue", "Slice"].map({$0.components(separatedBy: CharacterSet.symbols).joined().trimmingCharacters(in: .whitespaces)})

let sections = arr.sorted(by: { $0 < $1 })
print(sections)
//: [Next](@next)

var someArray = [1, 2, 3]
let uhOh = someArray.withUnsafeBufferPointer { ptr in
    return ptr
}

print(uhOh[1])

var x = [1, 2, 3]
x.append(4)
x

enum TextAlignment {
    case left
    case center
    case right
}

extension TextAlignment {
    init(defaultFor locale: Locale) {
        guard let language = locale.languageCode else {
            self = .left
            return
        }
        switch Locale.characterDirection(forLanguage: language) {
        case .rightToLeft:
            self = .right
        case .leftToRight, .topToBottom, .bottomToTop, .unknown:
            self = .left
        @unknown default:
            self = .left
        }
    }
}

let english = Locale(identifier: "en_AU")
TextAlignment(defaultFor: english)
