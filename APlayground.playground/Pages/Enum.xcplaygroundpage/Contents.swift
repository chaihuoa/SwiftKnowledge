//: [Previous](@previous)

import Foundation
import UIKit

public enum Optional<Wrapped>: ExpressibleByNilLiteral {
    case none
    case some(Wrapped)
    
    public init(_ some: Wrapped) {
        self = .some(some)
    }
    
    public init(nilLiteral: ()) {
        self = .none
    }
}

enum Trade {
    case Buy(stock: String, amount: Int)
    case Sell(stock: String, amount: Int)
}

let trade = Trade.Buy(stock: "APPL", amount: 500)
if case let Trade.Buy(stock, amount) = trade {
    print("buy \(amount) of \(stock)")
}

// 枚举声明的类型是囊括可能状态的有限集，且可以具有附加值。通过内嵌(nesting),方法(method),关联值(associated values)和模式匹配(pattern matching),枚举可以分层次地定义任何有组织的数据。

// restricted limited finite
// The type of enumeration declaration is a finite set of possible states, and can have additional values. Enumerations can define any organized data hierarchically through nesting, method, associated values and pattern matching.

// Methods and Properties

// The main difference to struct or class types is that you can switch on self within the method in order to calculate the output.

enum Character {
   case wizard(name: String, level: Int)
   case warior(name: String, level: Int)
}

extension Character {
   var level: Int {
     switch self {
     case .wizard(_, let level): return level
     case .warior(_, let level): return level
     }
   }
}

let seniorWizard = Character.wizard(name: "hkjf", level: 10)
seniorWizard.level

// The advantage over structs being the ability to encode categorization and hierachy:

// Struct Example

struct Point { let x: Int, y: Int }

struct Rect { let x: Int, y: Int, width: Int, height: Int }



// Enum Example

enum GeometricEntity {

    case point(x: Int, y: Int)

    case rect(x: Int, y: Int, width: Int, height: Int)

}


protocol AccountCompatible {
   var remainingFunds: Int { get }
   mutating func addFunds(amount: Int) throws
   mutating func removeFunds(amount: Int) throws
}

enum Account {
   case empty
   case funds(remaining: Int)
   case credit(amount: Int)

   var remainingFunds: Int {
     switch self {
     case .empty: return 0
     case .funds(let remaining): return remaining
     case .credit(let amount): return amount
     }
   }
}

extension Account: AccountCompatible {

   mutating func addFunds(amount: Int) {

     var newAmount = amount

     if case let .funds(remaining) = self {
       newAmount += remaining
     }

     if newAmount < 0 {
         self = .credit(amount: newAmount)
     } else if newAmount == 0 {
       self = .empty
     } else {
       self = .funds(remaining: newAmount)
     }
   }

   mutating func removeFunds(amount: Int) throws {
       self.addFunds(amount: amount * -1)
   }
}

var account = Account.funds(remaining: 20)
account.addFunds(amount:10)
try account.removeFunds(amount:15)


enum Either<T1, T2> {

   case left(T1)

   case right(T2)

}

indirect enum Tree<Element: Comparable> {
     case empty
     case node(Tree<Element>,Element,Tree<Element>)
}

//Custom Data Types

//extension CGSize: ExpressibleByStringLiteral {
//
//     public init(stringLiteral value: String) {
//
//         let components = rawValue.split(separator: ",")
//
//         guard components.count == 2,
//
//             let width = Int(components[0]),
//
//             let height = Int(components[1])
//
//             else { return fatalError("Invalid Format \(value)") }
//
//         self.init(width: size.width, height: size.height)
//     }
//}

//enum Devices: CGSize {
//    case iPhone3GS = "320,480"
//    case iPhone5 = "320,568"
//    case iPhone6 = "375,667"
//    case iPhone6Plus = "414,736"
//}

//let a = Devices.iPhone5
//let b = a.rawValue
//print("the phone size string is \(a), width is \(b.width), height is \(b.height)")
             
// Comparing Enums

// How to compare an enum with associated values?
// 1. conform Equatable if there is no custom type
// 2. otherwise implement a custom equatable conformance

// Not Equatable Stock

struct StockWithoutEqu {
    // ...
}

enum TradeWithCustomType {
     case buy(stock: StockWithoutEqu, amount: Int)
     case sell(stock: StockWithoutEqu, amount: Int)
}

//func ==(lhs: TradeWithCustomType, rhs: TradeWithCustomType) -> Bool {
//
//    switch (lhs, rhs) {
//
//    case let (.buy(stock1, amount1), .buy(stock2, amount2))
//
//          where stock1 == stock2 && amount1 == amount2:
//
//          return true
//
//    case let (.sell(stock1, amount1), .sell(stock2, amount2))
//
//          where stock1 == stock2 && amount1 == amount2:
//
//          return true
//
//    default: return false
//
//    }
//
//}

//Iterating over Enum Cases

//enum Drink: CaseIterable {
//   case beer
//   case cocktail(ingredients: [String])
//}

//: ## Enums in the Standard Library

enum APIError : Error {

     // Can't connect to the server (maybe offline?)

     case connectionError(error: NSError)

     // The server responded with a non 200 status code

     case serverError(statusCode: Int, error: NSError)

     // We got no data (0 bytes) back from the server

     case noDataError

     // The server response can't be converted from JSON to a Dictionary

     case JSONSerializationError(error: Error)

     // The Argo decoding Failed

//     case JSONMappingError(converstionError: DecodeError)

}

enum Liquid: Float {

   case ml = 1.0

   case l = 1000.0

   func convert(amount: Float, to: Liquid) -> Float {

       if self.rawValue < to.rawValue {

          return (self.rawValue / to.rawValue) * amount

       } else {

          return (self.rawValue * to.rawValue) * amount

       }

   }

}

let ml = Liquid.ml
ml.convert(amount: 1000, to: .ml)

//: ## Limitations

//: ### 1.Tuples
//: ### 2.Default Associated Values
//: ### 3.提取关联值

enum Ex { case Mode(ab: Int, cd: Int) }
//if case Ex.Mode(let ab, let cd) = Ex.Mode(ab: 4, cd: 5) {
//    print(ab)
//}
// vs tuples:
let tp = (ab: 4, cd: 5)
print(tp.ab)

//: ### 4.相等性

// Int 和 String 是可判等的, 所以 Mode 应该也是可判等的
//enum Ex { case Mode(ab: Int, cd: String) }

// Swift 应该能够自动生成这个函数
//func == (lhs: Ex.Mode, rhs: Ex.Mode) -> Bool {
//    switch (lhs, rhs) {
//       case (.Mode(let a, let b), .Mode(let c, let d)):
//       return a == c && b == d
//       default:
//       return false
//    }
//}

//: ### 迭代枚举的所有case

//: [Next](@next)
