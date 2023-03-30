//: [Previous](@previous)

import Foundation

protocol Fuel {
   
    // Constrain `FuelType` to always equal to the type that conforms to the `Fuel` protocol
    associatedtype FuelType where FuelType == Self

    static func purchase() -> FuelType
}

struct Gasoline: Fuel {
    
    let name = "gasoline"
    
    static func purchase() -> Gasoline {
        print("Purchase gasoline from gas station.")
        return Gasoline()
    }
}

struct Diesel: Fuel {
    
    let name = "diesel"
    
    static func purchase() -> Diesel {
        print("Purchase diesel from gas station.")
        return Diesel()
    }
}

protocol Vehicle {

    // `FuelType` must be type that conform to the `Fuel` protocol
    associatedtype FuelType: Fuel
    
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

func fillAllGasTank(for vehicles: [any Vehicle]) {

    for vehicle in vehicles {
        // Pass in `any Vehicle` to convert it to `some Vehicle`
        fillGasTank(for: vehicle)
    }
}

// Create a function that accept `some Vehicle` (opaque type)
func fillGasTank(for vehicle: some Vehicle) {

    let fuel = type(of: vehicle).FuelType.purchase()
    vehicle.fillGasTank(with: fuel)
}

fillAllGasTank(for: vehicles)

// https://swiftsenpai.com/swift/dynamic-dispatch-with-generic-protocols/

//: [Next](@next)
