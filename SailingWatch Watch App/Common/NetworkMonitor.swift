//
//  NetworkMonitor.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 02/06/24.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)
    @Published var isConnected: Bool = true
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
