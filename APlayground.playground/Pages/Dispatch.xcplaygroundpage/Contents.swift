//: [Previous](@previous)

import Foundation

let serialQueue = DispatchQueue(label: "com.example.serialQueue")

// 同步提交
serialQueue.sync {
    // 长时间运行的任务
    sleep(2) // 模拟耗时任务
    print("Sync task on serial queue")
}

// 异步提交
serialQueue.async {
    sleep(2) // 模拟耗时任务
    print("Async task on serial queue")
}

print("Main thread is not blocked by async task")


//let group = DispatchGroup()
//let cities = ["New York", "London", "Tokyo"]
//var weatherData = [String: Weather]()
//
//for city in cities {
//    group.enter()
//    fetchWeather(for: city) { result in
//        weatherData[city] = result
//        group.leave()
//    }
//}
//
//group.notify(queue: .main) {
//    updateUI(with: weatherData)
//}


// 线程和队列的关系


//: # 死锁问题

//let queueA = DispatchQueue(label: "queueA", attributes: .concurrent)
//let queueB = DispatchQueue(label: "queueB", attributes: .concurrent)
//
//queueA.async {
//    print("任务1开始在queueA")
//    queueB.sync {
//        print("任务1尝试访问queueB")
//        print("任务1尝试访问queueB")
//    }
//    print("任务1完成")
//}
//
//queueB.async {
//    print("任务2开始在queueB")
//    queueA.sync {
//        print("任务2尝试访问queueA")
//        print("任务2尝试访问queueA")
//    }
//    print("任务2完成")
//}


//: # Race Condition

//var likesCount = 100
//let lock = NSLock()
//
//DispatchQueue.global().async {
//    for _ in 1...10 {
//        // 模拟用户点赞
//        lock.lock() // 解决race condition的方式
//        likesCount += 1
//        lock.unlock()
//    }
//    print("当前点赞数（线程1）: \(likesCount)")
//}
//
//DispatchQueue.global().async {
//    for _ in 1...10 {
//        // 模拟用户点赞
//        lock.lock() // 解决race condition的方式
//        likesCount += 1
//        lock.unlock()
//    }
//    print("当前点赞数（线程2）: \(likesCount)")
//}
//
//print("最后当前点赞数: \(likesCount)")

// 下面的为啥要用group？那是因为我创建的是两个异步任务，最后的print方法会在这两个异步任务完成前执行

var likesCount = 100
let lock = NSLock()
let group = DispatchGroup()

DispatchQueue.global().async(group: group) {
    for _ in 1...10 {
        lock.lock()
        likesCount += 1
        lock.unlock()
    }
    print("当前点赞数（线程1）: \(likesCount)")
}

DispatchQueue.global().async(group: group) {
    for _ in 1...10 {
        lock.lock()
        likesCount += 1
        lock.unlock()
    }
    print("当前点赞数（线程2）: \(likesCount)")
}

group.notify(queue: .main) {
    print("最后当前点赞数: \(likesCount)")
    print("最后当前点赞数: \(likesCount)")
}


//: [Next](@next)
