//: [Previous](@previous)

import Foundation
import UIKit

enum ImageFetchingError: Error {
    case timeout
    case unknown
}

protocol CatImageCellModel {
    var placeholderImage: UIImage { get }
    func fetchCatImage(completion: @escaping (Result<UIImage, ImageFetchingError>) -> Void)
}

final class CatImageCell: UICollectionViewCell {

    private var imageView: UIImageView!
    private var maxRetryCount = 2
    private var currentModel: CatImageCellModel?
    private var modelIdentifier: String?

    convenience init(imageView: UIImageView) {
        self.init()

        self.imageView = imageView
    }

    override func prepareForReuse() {
        imageView.image = nil
        currentModel = nil
        maxRetryCount = 0
        modelIdentifier = nil
    }

    func set(model: CatImageCellModel) {
        currentModel = model
        imageView.image = model.placeholderImage
        modelIdentifier = UUID().uuidString
        if let currentModel = currentModel, let modelIdentifier = modelIdentifier {
            fetchCatImage(model: currentModel, modelIdentifier: modelIdentifier)
        }
    }

    func fetchCatImage(model: CatImageCellModel, modelIdentifier: String) {
        model.fetchCatImage() { [weak self] (result: Result<UIImage, ImageFetchingError>) in
            guard let self = self else { return }
            guard self.modelIdentifier == modelIdentifier else { return }

            DispatchQueue.main.async {
                switch result {
                    case .success(let response):
                        self.imageView.image = response
                    case .failure(let error):
                        if error == .timeout {
                            if self.maxRetryCount > 0 {
                                self.maxRetryCount -= 1
                                self.fetchCatImage(model: model, modelIdentifier: modelIdentifier)
                            } else {
                                self.imageView.image = model.placeholderImage
                            }
                        } else if error == .unknown {
                            self.imageView.image = model.placeholderImage
                        }
                }
            }
        }
    }
}

let key = DispatchSpecificKey<String>()

DispatchQueue.main.setSpecific(key: key, value: "main")

func log() {
  debugPrint("main thread: \(Thread.isMainThread)")
  let value = DispatchQueue.getSpecific(key: key)
  debugPrint("main queue: \(value != nil)")
}

DispatchQueue.global().sync(execute: log)
RunLoop.current.run()

func deadLock() {
    let queue = DispatchQueue(label: "deadlock-demo")
    queue.async { // A
        queue.sync { // B
            print("B: Waiting on A to finish.")
        }
        print("A: Waiting on B to finish.")
    }
}

deadLock()

//: [Next](@next)
