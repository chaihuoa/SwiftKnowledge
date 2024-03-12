//: [Previous](@previous)

import Foundation

class Address {
    var city: String
    
    init(city: String) {
        self.city = city
    }
}

struct Product {
    let productId: String
    var title: String
    let price: Double
    var quantity: Int
    let address: Address
    
    mutating func consumProduct() {
        quantity -= 1
    }
}

var apple = Product(productId: "123321", title: "Red Apple", price: 1.69, quantity: 100, address: Address(city: "Shanghai"))

var appleCopy = apple

apple.title = "Bad Apple"
apple.quantity = 99
apple.address.city = "Beijing"

appleCopy.quantity

apple
appleCopy

// struct里包含class，struct任然是值类型，class任然是引用类型。他们还是各论各的。

//: [Next](@next)
