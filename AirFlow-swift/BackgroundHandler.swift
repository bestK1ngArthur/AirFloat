//
//  BackgroundHandler.swift
//  AirFlow-swift
//
//  Created by bestK1ng on 01/03/2019.
//

import UIKit

protocol BackgroundHandlerDelegate: AnyObject {
    func doBackgroundTask()
}

class BackgroundHandler: NSObject {
    
    weak var delegate: BackgroundHandlerDelegate?
    
    private var backgroundTaskStartupDelay: TimeInterval {
        let target: TimeInterval = 10
        var startupDelay: TimeInterval = 0
        
        if backgroundTaskTimeLimit >= target {
            startupDelay = backgroundTaskTimeLimit - target
        }
        
        return startupDelay
    }
    
    private var maxBackgroundTasksCount = 2;
    private var backgroundTaskCount = 0
    private var backgroundTaskTimeLimit: TimeInterval = 0
    
    private var backgroundTask = UIBackgroundTaskIdentifier(rawValue: 0)
    private var helperBackgroundTask = UIBackgroundTaskIdentifier(rawValue: 0)
    
    private var helperBackgroundTaskClosure: (() -> Void)?
    
    func handleBackgroundTasks() {
        
        guard UIDevice.current.isMultitaskingSupported else {
            return
        }
        
        setBackgroundTaskTimeLimit()
        doBackgroundTaskAsync()
        perform(#selector(keepAlive), with: nil, afterDelay: backgroundTaskStartupDelay)
    }
    
    func handleForegroundTasks() {
        backgroundTaskCount = 0
        stopHelperBackgroundTask()
        stopBackgroundTask()
    }
    
    private func startHelperBackgroundTask() {
        
        helperBackgroundTaskClosure = {
            Thread.current.name = "helperBackgroundTaskBlock.init"
            UIApplication.shared.endBackgroundTask(self.helperBackgroundTask)
            self.helperBackgroundTask = UIBackgroundTaskIdentifier.invalid
            self.helperBackgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: self.helperBackgroundTaskClosure)
        }
        
        helperBackgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: helperBackgroundTaskClosure)
    }
    
    private func stopHelperBackgroundTask() {
        
        helperBackgroundTaskClosure = {
            Thread.current.name = "helperBackgroundTaskBlock.stopped"
            UIApplication.shared.endBackgroundTask(self.helperBackgroundTask)
            self.helperBackgroundTask = UIBackgroundTaskIdentifier.invalid
        }

        UIApplication.shared.endBackgroundTask(helperBackgroundTask)
        helperBackgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
    private func stopBackgroundTask() {
    
        let identifier = backgroundTask
        backgroundTask = UIBackgroundTaskIdentifier(rawValue: 0)
        UIApplication.shared.endBackgroundTask(identifier)
    }
    
    private func setBackgroundTaskTimeLimit() {
        startHelperBackgroundTask()
        
        // Wait for background async task by 'OhadM':
        // http://stackoverflow.com/a/31893720

        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .background).async {
            
            autoreleasepool {
                Thread.current.name = "setBackgroundTaskTimeLimit.dispatch_async"
                self.backgroundTaskTimeLimit = UIApplication.shared.backgroundTimeRemaining
            }
            
            semaphore.signal()
        }
        
        semaphore.wait(timeout: .distantFuture)
        stopHelperBackgroundTask()
    }
    
    private func doBackgroundTaskAsync() {
        
        if UIApplication.shared.applicationState != .background || backgroundTaskCount >= maxBackgroundTasksCount {
            return
        }
        
        startHelperBackgroundTask()
        backgroundTaskCount += 1
        
        DispatchQueue.global(qos: .background).async {
            Thread.current.name = "doBackgroundTaskAsync.dispatch_async"
            
            while UIApplication.shared.applicationState == .background {
                self.perform(#selector(self.keepAlive))
                sleep(5)
            }
        }
    }
    
    @objc private func keepAlive() {
        delegate?.doBackgroundTask()
    }
}
