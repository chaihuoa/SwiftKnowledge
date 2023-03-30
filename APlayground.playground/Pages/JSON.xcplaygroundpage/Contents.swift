//: [Previous](@previous)

import Foundation

// Swift 写一个函数把各种变量（dictionary，array，string，primitives）转为 JSON

/*
func arrayToJSON(_ array: [Any]) -> Data? {
    do {
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        return data
    } catch {
        print(error)
        return nil
    }
}

let array = ["one", "two", "three"]
let data = arrayToJSON(array)

struct Person: Codable {
    let name: String
    let age: Int
}

func personToJSON(person: Person) -> Data? {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(person)
        return data
    } catch {
        print(error)
        return nil
    }
}

let person = Person(name: "Kit", age: 8)
let pData = personToJSON(person: person)
*/

protocol JSONConvertible {
    func toJSONData() -> Data?
}

protocol JSONInitializable {
    init?(jsonData: Data)
}

struct Person: Codable, JSONConvertible, JSONInitializable {
    let name: String
    let age: Int

    init?(jsonData: Data) {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(Person.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
    }

    func toJSONData() -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}

extension Array: JSONInitializable, JSONConvertible where Element: Codable {
    init?(jsonData: Data) {
        let decoder = JSONDecoder()
        do {
            self = try decoder.decode(Array.self, from: jsonData)
        } catch {
            print(error)
            return nil
        }
    }
    
    func toJSONData() -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error)
            return nil
        }
    }
}

struct User: Codable {
    let name: String
    let age: Int
}

let users: [User] = [User(name: "John", age: 30), User(name: "Jane", age: 28)]

if let jsonData = users.toJSONData() {
    let jsonString = String(data: jsonData, encoding: .utf8)!
    print(jsonString)
}

let jsonString = "[{\"name\":\"John\",\"age\":30},{\"name\":\"Jane\",\"age\":28}]"
if let jsonData = jsonString.data(using: .utf8),
   let deserializedUsers = [User].init(jsonData: jsonData) {
    print(deserializedUsers)
}



//: [Next](@next)
