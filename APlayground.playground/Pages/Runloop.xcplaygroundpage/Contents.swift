//: [Previous](@previous)

import Foundation

/*
 面试时被问到对RunLoop的理解，尤其是对于一个资深iOS开发专家的岗位，你的回答应该包含RunLoop的基本概念、作用、组成部分、以及在实际开发中的应用。下面是一个可能的回答框架，你可以根据自己的理解和经验进行调整和扩展：

 基本概念
 RunLoop是iOS和macOS核心框架中的一个循环机制，用于管理线程的事件循环。它使线程能在有工作时执行任务，在没有工作时休眠，以节省资源。每个线程包括主线程都有与之相关联的RunLoop，但是除了主线程外，其他线程的RunLoop默认不会启动。

 作用
 事件处理：RunLoop是应用处理用户输入（如触摸、滚动）、定时器事件、网络请求回调等事件的基础设施。它让线程在等待这些事件时保持休眠状态，从而提高应用性能和响应速度。

 线程存活：通过在没有实际工作时让线程休眠，RunLoop使后台线程能长时间运行而不被系统终止。这对于实现如网络监听等长期后台任务特别重要。

 组成部分
 事件源（Sources）：分为两种类型，System Sources和Custom Sources，负责向RunLoop提供待处理的事件。

 定时器（Timers）：在指定的时间点触发事件，由RunLoop处理。

 观察者（Observers）：允许在RunLoop的不同阶段插入自定义的处理逻辑，比如在处理事件前后进行某些操作。

 实际应用
 在开发中，我们经常利用RunLoop来处理UI更新、执行后台任务、优化性能。例如，通过在子线程的RunLoop中安排网络请求的回调，可以避免在主线程上直接处理耗时操作，从而保持UI的流畅性。

 利用观察者，我们可以监控应用状态，如监测主线程的卡顿情况，通过分析RunLoop的各个阶段耗时来进行性能优化。

 深入理解
 对于一个资深iOS开发专家来说，不仅需要理解RunLoop的基础，还需要了解其在底层的工作原理，如何在复杂场景下正确使用RunLoop来提高应用的性能和稳定性。还需要知道如何避免常见的陷阱，比如错误的使用方式可能导致的内存泄露、性能下降或应用崩溃等问题。

 了解如何结合GCD和NSOperationQueue使用RunLoop，以及在多线程编程中正确管理RunLoop，以确保应用的高效和响应性。

 结论
 作为一个资深iOS开发专家，理解并能够熟练应用RunLoop，不仅可以帮助开发高性能的iOS应用，还能够在面对复杂的并发和异步编程挑战时，设计出更优雅的解决方案。
 */

// 线程存活
// 监听来自网络的数据

class PersistentThread {
    private var thread: Thread?
    private var isRunning = false
    
    // 启动线程和其RunLoop
    func start() {
        isRunning = true
        
        // 创建线程，并指定执行的方法
        thread = Thread { [weak self] in
            autoreleasepool {
                // 向当前线程的RunLoop添加一个定时器，防止RunLoop立即退出
                let runLoop = RunLoop.current
                runLoop.add(NSMachPort(), forMode: .default)
                
                while let strongSelf = self, strongSelf.isRunning {
                    // 启动RunLoop
                    runLoop.run(until: Date().addingTimeInterval(1))
                }
            }
        }
        
        // 启动线程
        thread?.start()
    }
    
    // 停止线程和其RunLoop
    func stop() {
        isRunning = false
    }
    
    // 线程中执行的任务
    func performTask(_ task: @escaping () -> Void) {
        // 确保任务在自定义线程的上下文中执行
        thread?.perform {
            task()
        }
    }
}

// 使用
let persistentThread = PersistentThread()
persistentThread.start()

// 在自定义线程上执行任务
persistentThread.performTask {
    print("任务在持久化线程上执行")
}

// 停止线程（根据需要调用）
// persistentThread.stop()


// 卡顿监测


class LagMonitor {
    private var observer: CFRunLoopObserver?
    private var lagTimes: [TimeInterval] = []
    private let threshold: TimeInterval = 1.0 / 60.0 * 2 // 两帧的时间，约33.3ms
    private let window: TimeInterval = 2.0 // 检测窗口设置为2秒
    private let lagCountThreshold = 5 // 2秒内连续超过阈值5次视为卡顿
    
    init() {
        let callback: CFRunLoopObserverCallBack = { observer, activity, info in
            guard let info = info else { return }
            let monitor = Unmanaged<LagMonitor>.fromOpaque(info).takeUnretainedValue()
            
            monitor.check(activity: activity)
        }
        
        observer = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.beforeSources.rawValue | CFRunLoopActivity.afterWaiting.rawValue, true, 0, callback, nil)
        
        CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
    }
    
    private func check(activity: CFRunLoopActivity) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        switch activity {
        case .beforeSources:
            lagTimes.append(currentTime)
        case .afterWaiting:
            lagTimes = lagTimes.filter { currentTime - $0 < window }
            if lagTimes.count >= lagCountThreshold {
                print("检测到UI卡顿")
                handleLagDetected()
                lagTimes.removeAll() // 检测到卡顿后清空记录
            }
        default: break
        }
    }
    
    deinit {
        if let observer = observer {
            CFRunLoopRemoveObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.commonModes)
        }
    }
}

// 假设这是检测到卡顿时的处理方法
func handleLagDetected() {
    let stackTrace = captureStackTrace()
    let formattedStackTrace = formatStackTrace(stackTrace)
    
    // 以下是示例操作，实际应用中你可能需要将信息记录到日志或上传到服务器
    print("Detected lag with stack trace:\n\(formattedStackTrace)")
    
    // 这里添加上传逻辑
    // 假设我们有一个函数uploadLagReport来上传卡顿信息
    // uploadLagReport(formattedStackTrace)
}


func captureStackTrace() -> [String] {
    return Thread.callStackSymbols
}

func formatStackTrace(_ stackTrace: [String]) -> String {
    return stackTrace.joined(separator: "\n")
}

struct LagReport {
    let timestamp: TimeInterval
    let stackTrace: String
    let deviceInfo: String
    let appVersion: String
    
    var json: [String: Any] {
        return [
            "timestamp": timestamp,
            "stackTrace": stackTrace,
            "deviceInfo": deviceInfo,
            "appVersion": appVersion
        ]
    }
}




//: [Next](@next)
