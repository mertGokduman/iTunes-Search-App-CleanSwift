//
//  ImageDownloadOperation.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 8.04.2023.
//

import Foundation

class DownloadOperation : Operation {

    private var task : URLSessionDataTask!

    enum OperationState : Int {
        case ready
        case executing
        case finished
    }

    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }

        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }

    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }

    init(session: URLSession,
         downloadTaskURL: URL,
         completionHandler: ((Data?, URLResponse?, Error?) -> Void)?) {
        super.init()

        task = session.dataTask(with: downloadTaskURL, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            if let completionHandler = completionHandler {
                completionHandler(data, response, error)
            }
            self.state = .finished
        })
    }

    override func start() {
        if(self.isCancelled) {
            state = .finished
            return
        }

        // set the state to executing
        state = .executing
        // start the downloading
        self.task.resume()
    }

    override func cancel() {
        super.cancel()

        // cancel the downloading
        self.task.cancel()
    }
}
