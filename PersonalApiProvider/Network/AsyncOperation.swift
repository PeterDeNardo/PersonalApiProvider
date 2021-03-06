//
//  AsyncOperation.swift
//  MagaluGist
//
//  Created by Peter De Nardo on 29/09/21.
//

import Foundation

open class AsyncOperation: Operation {
    
    private enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        case cancelled = "Cancelled"
        
        var key: String { return "is" + self.rawValue }
    }
    
    private var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.key)
            willChangeValue(forKey: newValue.key)
        }
        didSet {
            didChangeValue(forKey: state.key)
            didChangeValue(forKey: oldValue.key)
        }
    }
    
    public final override var isReady: Bool { return state == .ready && super.isReady }
    
    public final override var isExecuting: Bool { return state == .executing }
    
    public final override var isFinished: Bool { return state == .finished }
    
    public final override var isCancelled: Bool { return state == .cancelled }
    
    public final override var isAsynchronous: Bool { return true }
    
    public final override func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        state = .executing
        main()
    }
    
    open override func main() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing
        }
    }
    
    public final func finish() {
        state = .finished
    }
}
