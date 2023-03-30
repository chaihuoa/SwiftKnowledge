//: [Previous](@previous)

import Foundation
// We can specify a capture list in our closure’s definition which will create an immutable read-only copy of the variables we’ve listed. This way, changes made within the closure’s definition will not affect the value of the variables outside of the closure.

var x = 0
let incrementByThree = { [x] in
    // x += 3
    // Left side of mutating operator isn't mutable: 'x' is an immutable capture
    print(x)
}
incrementByThree()
print(x) // prints 0

// In simple terms, if the closure will be called after the function returns, we’ll need to add the @escaping keyword. Since the closure is called at a later date the system will have to store it in memory. So, because the closure is a reference type, this will create a strong reference to all objects referenced in its body.
// So, @escaping is used to indicate to callers that this function can potentially introduce a retain cycle and that they’ll need to manage this potential risk accordingly.


// Escaping closure captures non-escaping parameter 'closure'

//func escapingClosure(closure: (()->())) {
//    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//        closure()
//    }
//}

func escapingClosure(closure: @escaping (()->())) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        closure()
    }
}

var a = 0
escapingClosure {
    a += 2
    print(a)
}

a // 0

func nonEscapingClosure(closure: (()->())) {
    closure()
}

// As an added benefit, we can use the self keyword here without worrying about introducing a retain cycle.

struct Money {
    let value: Int
    let currencyCode: String
}

var money = Money(value: 20, currencyCode: "USD")

print(money)

let closure = { [money] in
    print(money)
}

money = Money(value: 200, currencyCode: "USD")

closure()

print(money)


//: [Next](@next)
