//
//  SailingWatchApp.swift
//  SailingWatch Watch App
//
//  Edited by Francesco Vezzani on 01/06/24.
//

import SwiftUI
import WatchKit

@main
struct SailingWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var storeManager = StoreManager()
    
    var body: some Scene {
        WindowGroup {
            MainView(storeManager: storeManager)
        }
    }
}

class AppDelegate: NSObject, WKApplicationDelegate {
    // No additional setup required for now
}
