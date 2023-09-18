//
//  NetworkViewModel.swift
//  MediaApp
//
//  Created by Abhishek Pandey on 12/09/23.
//

import Foundation
import Combine

class NetworkViewModel: ObservableObject {
    
    //MARK: - Properties
    @Published var isNetworkAvailable = true
    @Published var isRefresh = true
    private var networkMonitor: Reachability

    //MARK: - Injection
    init(networkMonitor: Reachability) {
        self.networkMonitor = networkMonitor
        startMonitoring()
    }

    private func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkChange), name: .reachabilityChanged, object: networkMonitor)
        networkMonitor.whenReachable = { _ in
            self.isNetworkAvailable = true
        }
        networkMonitor.whenUnreachable = { _ in
            self.isNetworkAvailable = false
        }

        do {
            try networkMonitor.startNotifier()
        } catch {
            debugPrint("Unable to start notifier")
        }
    }

    @objc func handleNetworkChange() {
        isRefresh = true
        if networkMonitor.connection != .unavailable {
            isNetworkAvailable = true
        } else {
            isNetworkAvailable = false
        }
    }
}
