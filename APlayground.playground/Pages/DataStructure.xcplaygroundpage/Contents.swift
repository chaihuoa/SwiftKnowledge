//: [Previous](@previous)

struct Movie {
    var review: Float
}

extension Array where Element == Movie {
    var averageReview: Float {
        guard !isEmpty else {
            return 0
        }
        
//        var totalPoints: Float = 0
//        for item in self {
//            totalPoints += item.review
//        }
        let totalPoints = self.reduce(into: 0, {$0 += ($1.review )})
        
        return totalPoints / Float(count)
    }
}

let comdey = Movie(review: 5.0)
let action = Movie(review: 4.0)

let movies = [comdey, action]
movies.averageReview

import Foundation

func reverseString(_ s: inout [Character]) {
    if s.count == 0 {
        return
    }
    s = s.reversed()
}

//let str = "I Love You"
//reverseString(Character(str))

class LinkedListNode<T> {
    var value: T
    var previous: LinkedListNode?
    var next: LinkedListNode?
    
    init(value: T) {
        self.value = value
    }
}

class LinkedList<T> {
    typealias Node = LinkedListNode<T>
    var head: Node?
    var first: Node? {
        return head
    }
    
    var last: Node? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        
        return node
    }
}

struct Stack<Element> {
    public private(set) var items = [Element]() // Empty items array
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        if !items.isEmpty {
           return items.removeLast()
        }
        return nil
    }
}

var stack = Stack<Float>()
stack.push(4.0)
stack.push(78)
stack.items // [4, 78]
stack.pop()
stack.items // [4]
stack.pop()

struct Queue<Element> {
    private(set) var items = [Element]()
    
    mutating func enqueue(_ item: Element) {
        items.append(item)
    }
    
    mutating func dequeue() -> Element? {
        if !items.isEmpty {
            return items.removeFirst()
        }
        return nil
    }
}

var queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.items
queue.dequeue()
queue.items

//: [Next](@next)
