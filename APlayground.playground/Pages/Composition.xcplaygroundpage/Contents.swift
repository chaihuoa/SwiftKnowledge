//: [Previous](@previous)

import Foundation
import UIKit

protocol FeedLoader {
    func loadFeed(completion: @escaping (([String]) -> Void))
}

class FeedViewController: UIViewController {
//    var remoteLoader: RemoteFeedLoader!
//    var localLoader: LocalFeedLoader!
    var loader: FeedLoader!
    
//    convenience init(remoteLoader: RemoteFeedLoader, localLoader: LocalFeedLoader) {
//        self.init()
//        self.remoteLoader = remoteLoader
//        self.localLoader = localLoader
//    }
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if Reachability.networkAvailable {
//            remoteLoader.loadFeed { loadedItems in
//                // do something
//            }
//        } else {
//            localLoader.loadFeed { loadedItems in
//                // do something
//            }
//        }
        
        loader.loadFeed { loadedItems in
            // do something
        }
    }
}

class RemoteFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping (([String]) -> Void)) {
        //
    }
}

class LocalFeedLoader: FeedLoader {
    func loadFeed(completion: @escaping (([String]) -> Void)) {
        //
    }
}

struct Reachability {
    static let networkAvailable = true
}

class RemoteWithLocalFallbackFeedLoader: FeedLoader {
    let remote: RemoteFeedLoader!
    let local: LocalFeedLoader!
    
    init(remote: RemoteFeedLoader, local: LocalFeedLoader) {
        self.remote = remote
        self.local = local
    }
    
    func loadFeed(completion: @escaping (([String]) -> Void)) {
        let loader = Reachability.networkAvailable ? remote.loadFeed : local.loadFeed
        loader(completion)
    }
}

let vc1 = FeedViewController(loader: RemoteFeedLoader())
let vc2 = FeedViewController(loader: LocalFeedLoader())

let loader = RemoteWithLocalFallbackFeedLoader(remote: RemoteFeedLoader(), local: LocalFeedLoader())
let vc3 = FeedViewController(loader: loader)

//: [Next](@next)
