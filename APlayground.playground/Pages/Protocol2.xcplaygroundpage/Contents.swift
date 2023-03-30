//: [Previous](@previous)

import Foundation

struct Gasoline {
    let name = "gasoline"
}

struct Diesel {
    let name = "diesel"
}

protocol Vehicle {

    associatedtype FuelType
    
    var name: String { get }

    func startEngin()
    func fillGasTank(with fuel: FuelType)
}

struct Car: Vehicle {

    let name: String

    func startEngin() {
        print("\(name) enjin started!")
    }

    func fillGasTank(with fuel: Gasoline) {
        print("Fill \(name) with \(fuel.name)")
    }
}

struct Bus: Vehicle {

    let name: String

    func startEngin() {
        print("\(name) enjin started!")
    }

    func fillGasTank(with fuel: Diesel) {
        print("Fill \(name) with \(fuel.name)")
    }
}

// Heterogeneous array with `Car` and `Bus` elements
// in Swift 5.6: 🔴 Compile error: Protocol ‘Vehicle’ can only be used as a generic constraint because it has Self or associated type requirements
let vehicles: [any Vehicle] = [
    Car(name: "Car_1"),
    Car(name: "Car_2"),
    Bus(name: "Bus_1"),
    Car(name: "Car_3"),
]

func startAllEngin(for vehicles: [any Vehicle]) {
    for vehicle in vehicles {
        vehicle.startEngin()
    }
}

// Execution
startAllEngin(for: vehicles)

// Performing Dynamic Dispatch on Function with Generic Parameters

//func fillAllGasTank(for vehicles: [any Vehicle]) {
//
//    for vehicle in vehicles {
//        // 🤔 What to pass in here?
//        vehicle.fillGasTank(with: ????)
//    }
//}

//: [Next](@next)
