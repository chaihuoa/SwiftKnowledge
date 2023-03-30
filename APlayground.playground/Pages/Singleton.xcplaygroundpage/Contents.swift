//: [Previous](@previous)

import Foundation
import UIKit

// Main module

extension ApiClient {
    func login(completion: (LoggedInUser) -> Void) {}
}

// Api module

//class ApiClient {
//    static let shared = ApiClient()
//
//    func login(completion: (LoggedInUser) -> Void) {}
//    func loadFeed(completion: (FeedItem) -> Void) {}
//}

class ApiClient {
    static let shared = ApiClient()
    
    func execute(_ : URLRequest, completion: (Data) -> Void) {}
}

class MockApiClinet: ApiClient {
    
}

// Login module

struct LoggedInUser {}

class LoginViewController: UIViewController {
    var api = ApiClient.shared
    
    func didTapLoginButton() {
        api.login { user in
            // show next screen
        }
    }
}

// Feed module

struct FeedItem {}

class FeedService {
    var loadFeed: ((([FeedItem]) -> Void) -> Void)?
    
    func load() {
        loadFeed? { loadedItem in
            // update UI
        }
    }
}

//: [Next](@next)
