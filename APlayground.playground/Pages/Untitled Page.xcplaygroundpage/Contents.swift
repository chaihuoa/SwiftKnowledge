//: [Previous](@previous)

import Foundation

extension Optional {
    func map<T>(_ transform: (Wrapped) -> T) -> T? {
        guard let value = self else {
            return nil
        }
        return transform(value)
    }
}

//You're given an n number of nested array of integers.
//Your task is to convert that nested array into single level array without using builtin functions.
//let's say you have:
//a = [[2, 6],[[4, 6, 2], [7, 3, 8, 3],[7, 6, 5]],[3, 4, 3, 7]]
//it should become
//a = [2, 6, 4, 6, 2, 7, 3, 8, 3, 7, 6, 5, 3, 4, 3, 7]

//: [Next](@next)
