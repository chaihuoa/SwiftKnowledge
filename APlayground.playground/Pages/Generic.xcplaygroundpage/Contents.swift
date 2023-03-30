//: [Previous](@previous)

import Foundation

protocol Vehicle {

    associatedtype FuelType
    
    var name: String { get }

    func startEngin()
    func fillGasTank(with fuel: FuelType)
}

// The following 3 function signatures are identical.

func wash<T: Vehicle>(_ vehicle: T) {
    // Wash the given vehicle
}

/*
func wash<T>(_ vehicle: T) where T: Vehicle {
    // Wash the given vehicle
}

func wash(_ vehicle: some Vehicle)  {
    // Wash the given vehicle
}
 */

// -------------------

// 能否写一个 Swift 函数用于确定在任意数组中存储的任意类型的任何实例对象的类型。
func findType<T>(_ target: T) -> String {
    return String(describing: type(of: target))
}

// 能否写一个 Swift 函数用于查找在任意数组中存储的任意类型的任何实例对象的位置\索引。

extension Array where Element: Equatable {
    func position(_ target: Element) -> Int? {
        return self.firstIndex(of: target)
    }
}

func findIndex<T: Equatable>(of element: T, in array: [T]) -> Int? {
    return array.firstIndex(of: element)
}

let nums = [1, 2, 3, 4, 5]
nums.position(3)
findIndex(of: 3, in: nums)

//: [Next](@next)
