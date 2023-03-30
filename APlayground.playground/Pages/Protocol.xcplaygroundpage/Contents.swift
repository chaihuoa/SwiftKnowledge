//: [Previous](@previous)

import Foundation

// opaque existential container

func f<C: CustomStringConvertible>(_ x: C) -> Int {
    return MemoryLayout.size(ofValue: x)
}

func g(_ x: CustomStringConvertible) -> Int {
    return MemoryLayout.size(ofValue: x)
}

f(5) // 8
g(5) // 40

// Protocol as type

protocol Animal {
  var name: String { get }
  func makeNoise()
}

struct Cat: Animal {
  let name: String
  func makeNoise() {
    print("Meow!")
  }
}

struct Dog: Animal {
  let name: String
  func makeNoise() {
    print("Woof!")
  }
}

func makeNoise(animal: Animal) {
  animal.makeNoise()
}

let cat = Cat(name: "Fluffy")
let dog = Dog(name: "Buddy")

makeNoise(animal: cat) // prints "Meow!"
makeNoise(animal: dog) // prints "Woof!"

// Since Int and String types are Equatable themselves, Swift can automatically synthesize the == implementation for us.

//struct Money: Equatable {
//    let value: Int
//    let currencyCode: String
//}
//
//let money1 = Money(value: 20, currencyCode: "USD")
//let money2 = Money(value: 20, currencyCode: "USD")

//money1 == money2

struct Money: Hashable, Comparable {
    let value: Int
    let currencyCode: String
    
    static func < (lhs: Money, rhs: Money) -> Bool {
        lhs.value < rhs.value
    }
}

let money1 = Money(value: 20, currencyCode: "USD")
let money2 = Money(value: 20, currencyCode: "USD")

let moneys: Set<Money> = [money1, money2]
print(moneys)

// Use Self to limit protocol

protocol Squareable where Self: Numeric {
    func square() -> Self
}
extension Squareable {
    func square() -> Self {
self * self }
}

// associatedtype

protocol Iterator {
    associatedtype T
    func getNext() -> T
    func hasNext() -> Bool
}

class Collection<T>: Iterator {
//    typealias T = Int
    private let items: [T]
    private var index = 0
    
    init(items: [T]) {
        self.items = items
    }
    
    func getNext() -> T {
        let next = items[index]
        index += 1
        return next
    }
    
    func hasNext() -> Bool {
        return index < items.count
    }
}

var collection = Collection(items: ["1", "2", "3", "4", "5"])
while collection.hasNext() {
    let item = collection.getNext()
    print(item)
}

//: [Next](@next)
