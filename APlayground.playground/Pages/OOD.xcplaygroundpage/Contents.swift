//: [Previous](@previous)

import Foundation

//struct Item {
//    let name: String
//    let brand: String
//    var points: Int = 5
//}
//
//var item = Item(name: "itme1", brand: "item1", points: 1)
//item.points += 1
//
//print(item.points)

//class PointsCalculator {
//    let specialBrands = ["Ben_and_Jerry", "Klondike", "Dove", "Degree"]
//    var items = [Item]()
//    var totalPoints = 0
//
//    func addItem(_ item: Item) {
//        var newItem = item
//        // Check if the brand is a special brand
//        if specialBrands.contains(newItem.brand) {
//            newItem.points += 10
//            // Check if the item already exists in the items array
//            for existingItem in items {
//                if existingItem.name == newItem.name {
//                    newItem.points += 5
//                }
//            }
//        }
//        totalPoints += newItem.points
//        items.append(newItem)
//    }
//
//    func printItemizedList() {
//        for item in items {
//            print("\(item.name) - \(item.points)")
//        }
//    }
//
//    func printTotalPoints() {
//        print("Total: \(totalPoints) points.")
//    }
//}
//
//let calculator = PointsCalculator()
//calculator.addItem(Item(name: "Ben & Jerry chocolate ice cream", brand: "Ben_and_Jerry"))
//calculator.addItem(Item(name: "Klondike ice cream", brand: "Klondike"))
//calculator.addItem(Item(name: "Purity ice cream", brand: "Purity"))
//calculator.addItem(Item(name: "Mayfield ice cream", brand: "Mayfield"))
//calculator.addItem(Item(name: "Ben & Jerry vanilla ice cream", brand: "Ben_and_Jerry"))
//
//calculator.printItemizedList()
//calculator.printTotalPoints()



class Item {
    let name: String
    var point: Int
    let brand: Brand
    
    init(name: String, point: Int, brand: Brand) {
        self.name = name
        self.point = point
        self.brand = brand
    }

    func addPoint(_ value: Int) {
        point += value
    }
}

struct Brand: Equatable {
    let name: String
}

class PointManager {
    var items: [Item]

    init(items: [Item]) {
        self.items = items
    }

    func calculate(with specialBrands: [Brand]) {
        for (index, _) in items.enumerated() {
            items[index].addPoint(5)
        }
        
        for (index, _) in items.enumerated() {
            let item = items[index].brand
            if specialBrands.contains(where: { $0 == item }) {
                items[index].addPoint(10)
            }
        }
        
        for sbrand in specialBrands {
            var sitems = items.filter { $0.brand == sbrand }
            
            if sitems.count == 3 {
                for (index, _) in sitems.enumerated() {
                    if index < 2 {
                        sitems[index].addPoint(5)
                    }
                }
            } else if sitems.count > 1 {
                for (index, _) in sitems.enumerated() {
                    sitems[index].addPoint(5)
                }
                print(sitems)
            }
        }
        
    }

    func result() {
        items.forEach {
            print($0)
        }
    }
}

let Ben_and_Jerry = Brand(name: "Ben_and_Jerry")
let Klondike = Brand(name: "Klondike")
let Dove = Brand(name: "Dove")
let Degree = Brand(name: "Degree")
let Purity = Brand(name: "Purity")
let Mayfield = Brand(name: "Mayfield")

let item1 = Item(name: "Ben & Jerry chocolate ice cream", point: 0, brand: Ben_and_Jerry)
let item2 = Item(name: "Klondike ice cream", point: 0, brand: Klondike)
let item3 = Item(name: "Purity ice cream", point: 0, brand: Purity)
let item4 = Item(name: "Mayfield ice cream", point: 0, brand: Mayfield)
let item5 = Item(name: "Ben & Jerry vanilla ice cream", point: 0, brand: Ben_and_Jerry)

let specialBrands = [Ben_and_Jerry, Klondike, Dove, Degree]
let manager = PointManager(items: [item1, item2, item3, item4, item5])
manager.calculate(with: specialBrands)
manager.result()


struct Product {
    let name: String
    let price: Float
    let id: Int
    var stock: Int = 0
}

enum Payment {
    case coin(value: Float)
    case bill(value: Float)
}

enum VendingState {
    case wait
    case success(change: Float)
    case needMoreMoney(money: Float)
    case productNotAvailable(products: [Product])
}

class VendingMachine {
    var products: [Product]
    var state: VendingState = .wait
    private var money: Float = 0
    private var needMoney: Float = 0

    init(products: [Product]) {
        self.products = products
    }

    func showAllProducts()-> [Product] {
        return products
    }
    
    func insertMoney(_ payment:Payment) -> Bool {
        switch payment {
        case .coin(let value):
            money += value
        case .bill(let value):
            money += value
        }
        return true
    }

    func selectProducts(_ products: [Product]) {
        products.forEach { product in
            if let index = self.products.firstIndex(where: { $0.id == product.id }) {
                self.products[index].stock -= 1
            }
        }
        needMoney += products.reduce(0, { $0 + $1.price })
        
    }
    
    func pay() {
        if !checkProductAvailable(products) {
            return
        }
        checkMoney(with: needMoney)
    }

    private func checkProductAvailable(_ products: [Product]) -> Bool {
        if products.filter({ $0.stock < 0 }).count > 0 {
            state = .productNotAvailable(products: products)
            return false
        }
        return true
    }

    private func checkMoney(with needMoney: Float) {
        print(money)
        if money >= needMoney {
            let change = money - needMoney
            state = .success(change: change)
        } else {
            state = .needMoreMoney(money: needMoney - money)
        }
    }
}

let coke = Product(name: "coke", price: 0.25, id: 123321, stock: 2)
let pepsi = Product(name: "pepsi", price: 0.35, id: 434323, stock: 1)
let machine = VendingMachine(products: [coke, pepsi])

var products = machine.showAllProducts()
machine.insertMoney(.coin(value: 0.5))
machine.insertMoney(.bill(value: 1))
machine.selectProducts([products[1]])
machine.selectProducts([products[1]])
machine.pay()

switch machine.state {
case .success(let change):
    if change > 0 {
        print("return change: \(change)")
    }
    // give user products
case .needMoreMoney(let money):
    // ask user insert more money
    print("still need \(money)")
case .productNotAvailable(let products):
    print("products not available: \(products)")
case .wait:
    break
}


//: [Next](@next)
