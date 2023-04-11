//
//  InternetReachability.swift
//  iTunes-Search-App-VIP
//
//  Created by Mert Gökduman on 6.04.2023.
//

import Foundation
import Network

final class InternetReachability {
    /// Continuos monitoring of network
    static func monitorNetwork() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            let monitor = NWPathMonitor()

            monitor.pathUpdateHandler = { path in
                switch path.status {
                case .satisfied:
                    continuation.yield(true)
                case .unsatisfied, .requiresConnection:
                    continuation.yield(false)
                @unknown default:
                    continuation.yield(false)
                }
            }

            monitor.start(queue: DispatchQueue(label: "InternetConnectionMonitor"))

            continuation.onTermination = { _ in
                monitor.cancel()
            }
        }
    }
    ///Returns a single value
    static func isConnected() async -> Bool {
        typealias Continuation = CheckedContinuation<Bool, Never>
        return await withCheckedContinuation({ (continuation: Continuation) in
            let monitor = NWPathMonitor()

            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                switch path.status {
                case .satisfied:
                    continuation.resume(returning: true)
                case .unsatisfied, .requiresConnection:
                    continuation.resume(returning: false)
                @unknown default:
                    continuation.resume(returning: false)
                }
            }
            monitor.start(queue: DispatchQueue(label: "InternetConnectionMonitor"))
        })
    }
}
