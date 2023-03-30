//: [Previous](@previous)

import Foundation

// You’re designing a game where player A places tanks on a 10x10 grid. The other player, B, then has to guess where the tanks are and try to obtain ‘hits’ by guessing correctly.

// Design an algorithm to do the following:

// Take an input of positions where player A has placed their tanks, formatted as  an array of paired zero-index(x, y) numbers: [[1, 2], [0, 3], [4, 1], …]

// Take an input of guesses from player B, formatted the same way. Process the input and return an array of string results based on the following logci:

// Hit(“h”) - Guess was one of the coordinates of player A’s tanks
// Near-hit(“”nh) - Guess was within 1 position up/down/left/right of a tank
// Miss(“m”) - Guess was not within 1 position up/down/left/right of a tank

// If any tank placements or guesses are invalid coordinates, return a top-level array with simply 1 string: “invalid data”.

func processGuesses(tanks: [[Int]], guesses: [[Int]]) -> [String] {
    // Validate the input arrays
    for tank in tanks {
        if tank[0] < 0 || tank[0] > 9 || tank[1] < 0 || tank[1] > 9 {
            return ["invalid data"]
        }
    }
    for guess in guesses {
        if guess[0] < 0 || guess[0] > 9 || guess[1] < 0 || guess[1] > 9 {
            return ["invalid data"]
        }
    }

    // Initialize the results array
    var results = [String]()

    // Iterate over the guesses and process them
    for guess in guesses {
        // Check if the guess is a hit
        if tanks.contains(guess) {
            results.append("h")
        }
        else {
            // Check if the guess is a near-hit
            var isNearHit = false
            for tank in tanks {
                if abs(guess[0] - tank[0]) <= 1 && abs(guess[1] - tank[1]) <= 1 {
                    isNearHit = true
                    break
                }
            }
            if isNearHit {
                results.append("nh")
            }
            else {
                results.append("m")
            }
        }
    }

    return results
}

let tanks = [[1, 2], [0, 3], [4, 1]]
let guesses = [[1, 2], [1, 3], [5, 5]]
let results = processGuesses(tanks: tanks, guesses: guesses)
print(results) // Output: ["h", "nh", "m"]


func findNthSmallest(values: [Int], n: Int) -> Int {
    // Sort the values in ascending order
    let sortedValues = values.sorted()

    // Remove duplicate values
    var distinctValues: [Int] = []
    var valueCounts: [Int: Int] = [:]
    for value in sortedValues {
        if valueCounts[value] == nil {
            valueCounts[value] = 1
            distinctValues.append(value)
        }
    }

    // Check if the index is valid
    var index = n - 1
    if index < 0 || index >= distinctValues.count {
        return -1
    }

    // Return the nth smallest value
    return distinctValues[index]
}

let values = [10, 3, 8, 1, 5, 8, 10]
let n = 1
let result = findNthSmallest(values: values, n: n)
print(result) // Outputs: 3

extension Array where Element: Hashable & Comparable {
  func mostCommonElement(after povit: Element) -> (Element, Int)? {
    var elementCounts: [Element: Int] = [:]
    var isCounting = false

    for element in self {
      if element != povit && !isCounting {
        continue
      } else if element == povit && !isCounting {
        isCounting = true
        continue
      }
      elementCounts[element] = (elementCounts[element] ?? 0) + 1
    }

    // Find the element that appears the most number of times
    let sortedElements = elementCounts.sorted { $0.value > $1.value }

    guard let mostCommonElement = sortedElements.first?.key else {
      return nil
    }
      
    return (mostCommonElement, elementCounts[mostCommonElement]!)
  }
}

// Test the function
//let list = [1, 1, 1, 2, 3, 4, 4, 1] // 1 -> (1, 3)
let list = [1, 1, 1, 2, 3, 4, 4, 1] // 2 -> (4, 2)
//let list = ["red", "green", "blue", "green", "blue"] // "green" -> ("blue", 2)

let element = list.mostCommonElement(after: 2)
print(element)  // Outputs: (4, 2)

func solution(arr: [Int]) -> String {
    // Type your solution here
    // left_index = 2*i + 1
    // right_index = 2*i + 2
    guard arr.count > 0 else { return "" }
    
    var leftSum = treeSum(arr, index: 1)
    var rightSum = treeSum(arr, index: 2)
    
    if leftSum == rightSum { return "" }
    return leftSum > rightSum ? "Left" : "Right"
}

func treeSum(_ arr: [Int], index: Int) -> Int {
    guard index < arr.count && arr[index] != -1 else { return 0 }
    return arr[index] + treeSum(arr, index: 2*index + 1) + treeSum(arr, index: 2*index + 2)
}

solution(arr: [0])

//func solution(numbers: [Int]) -> Int {
//    // Type your solution here
//    guard var maximum = numbers.first else { return 0 }
//
//    for element in numbers.dropFirst() {
//        maximum = maximum > element ? maximum : element
//    }
//
//    return maximum
//}
//
//solution(numbers: [122, 2, 3, 4])

//: [Next](@next)
