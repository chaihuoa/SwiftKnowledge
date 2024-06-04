//: [Previous](@previous)

import Foundation

// 类型擦除
// 不同的泛型类型实例封装成了统一的类型，并存储在同一个数组中

protocol Identifiable {
    associatedtype Identifier
    var id: Identifier { get }
}

struct User: Identifiable {
    var id: String
}

struct Product: Identifiable {
    var id: String
}

let user = User(id: "user123")
let product = Product(id: "product456")

// 下面这行代码将会报错
// let tmp = [user, product]

// Heterogeneous collection literal could only be inferred to '[Any]'; add explicit type annotation if this is intentional
// Insert ' as [Any]'
// let tmp = [user, product] as [Any]

class AnyIdentifiable {
    private let _getId: () -> Any

    var id: Any {
        return _getId()
    }

    init<T: Identifiable>(_ identifiable: T) {
        self._getId = { identifiable.id }
    }
}

struct Employee: Identifiable {
    var id: Int
}

let employee = Employee(id: 123)
let anyIdentifiableEmployee = AnyIdentifiable(employee)

let anyIdentifiableUser = AnyIdentifiable(user)
let anyIdentifiableProduct = AnyIdentifiable(product)

var identifiableItems: [AnyIdentifiable] = []
identifiableItems.append(anyIdentifiableUser)
identifiableItems.append(anyIdentifiableProduct)
identifiableItems.append(anyIdentifiableEmployee)

for item in identifiableItems {
    print(item.id) // 可能输出String或Int类型的id
}



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
