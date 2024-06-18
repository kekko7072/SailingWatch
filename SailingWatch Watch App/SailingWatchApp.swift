//
//  SailingWatchApp.swift
//  SailingWatch Watch App
//
//  Edited by Francesco Vezzani on 01/06/24.
//

import SwiftUI
import WatchKit
import TipKit

@main
struct SailingWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("firstOpeningTimestamp") var firstOpeningTimestamp: Double?
    
    init() {
        if firstOpeningTimestamp == nil {
            firstOpeningTimestamp = Date().timeIntervalSince1970
            
            /// Log event - App first open
            LogManager.shared.logEvent(.appFirstOpen)
        }
        /// Configure Tip's data container
        try? Tips.configure()
        
        /// Log event - App launched
        LogManager.shared.logEvent(.appLaunched)
    }
    
    //@StateObject var storeManager = StoreManager()
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView(locationManager: locationManager)//, storeManager: storeManager)
        }
    }
}

class AppDelegate: NSObject, WKApplicationDelegate {
    // No additional setup required for now
}
