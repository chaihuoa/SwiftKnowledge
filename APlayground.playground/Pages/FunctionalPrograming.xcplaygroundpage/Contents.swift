//: [Previous](@previous)

import Foundation

/*
 associatedtype的使用示例
 
 考虑一个场景，你想定义一个协议，这个协议要求实现它的类型能够提供一个方法，这个方法返回某种类型的元素。因为你希望这个协议能够被各种不同类型的集合实现，且每种集合可能包含不同类型的元素，所以你不能事先指定一个具体的元素类型。这时，associatedtype就显得非常有用。
 */

protocol Container {
    associatedtype Item
    func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// 直接在实现中使用具体类型：

struct IntContainer: Container {
    typealias Item = Int
    // 实现Container协议的要求...
}

// 让编译器自动推断：

struct IntContainer: Container {
    // Swift可以自动推断Item为Int
    // typealias Item = Int // 这行可以省略
    private var items: [Int] = []
    
    func append(_ item: Int) {
        items.append(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Int {
        return items[i]
    }
}

protocol FunctionalTools {
    associatedtype Element
    func map<T>(_ transform: (Element) -> T) -> [T]
    func filter(_ predicate: (Element) -> Bool) -> [Element]
    func reduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> T) -> T
}

extension Array: FunctionalTools {
    func map<T>(_ transform: (Element) -> T) -> [T] {
        var result = [T]()
        for item in self {
            result.append(transform(item))
        }
        return result
    }
    
    func filter(_ predicate: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        for item in self {
            if predicate(item) {
                result.append(item)
            }
        }
        return result
    }
    
    func reduce<T>(_ initialResult: T, _ nextPartialResult: (T, Element) -> T) -> T {
        var result = initialResult
        for item in self {
            result = nextPartialResult(result, item)
        }
        return result
    }
}

// 使用 map 来转换数组中的元素
let numbers = [1, 2, 3, 4, 5]
let squaredNumbers = numbers.map { $0 * $0 }
print(squaredNumbers) // 打印: [1, 4, 9, 16, 25]

// 使用 filter 来筛选数组
let evenNumbers = numbers.filter { $0 % 2 == 0 }
print(evenNumbers) // 打印: [2, 4]

// 使用 reduce 来合并数组中的元素
let sum = numbers.reduce(0, +)
print(sum) // 打印: 15

// 不使用闭包实现map功能

protocol IntegerTransform {
    func transform(_ value: Int) -> Int
}

struct DoubleTransform: IntegerTransform {
    func transform(_ value: Int) -> Int {
        return value * 2
    }
}

extension Array where Element == Int {
    func customMap(transformer: IntegerTransform) -> [Int] {
        var result: [Int] = []
        for item in self {
            result.append(transformer.transform(item))
        }
        return result
    }
}

// 使用
let numbers = [1, 2, 3, 4, 5]
let doubler = DoubleTransform()
let doubledNumbers = numbers.customMap(transformer: doubler)
print(doubledNumbers)

// 高级的功能如惰性求值和函数组合

struct LazySequence<T>: Sequence {
    let generate: () -> AnyIterator<T>
    
    func makeIterator() -> AnyIterator<T> {
        return generate()
    }
}

extension Array {
    func lazyMap<U>(_ transform: @escaping (Element) -> U) -> LazySequence<U> {
        let generate: () -> AnyIterator<U> = {
            var current = self.makeIterator()
            return AnyIterator {
                return current.next().map(transform)
            }
        }
        return LazySequence(generate: generate)
    }
}

func compose<T, U, V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
    return { f(g($0)) }
}

let numbers = [1, 2, 3, 4, 5]

// 惰性求值示例
let lazySquares = numbers.lazyMap { $0 * $0 }
print(Array(lazySquares)) // [1, 4, 9, 16, 25]

// 函数组合示例
func square(_ x: Int) -> Int {
    return x * x
}

func increment(_ x: Int) -> Int {
    return x + 1
}

let incrementAndSquare = compose(square, increment)
print(incrementAndSquare(2)) // 9


//: [Next](@next)
