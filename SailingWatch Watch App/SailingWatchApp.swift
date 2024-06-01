//
//  SailingWatchApp.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 12/09/23.
//
// SailingWatch_Watch_AppApp
import SwiftUI
import WatchKit

@main
struct SailingWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            TabView {
                TimerView()
                GPSView()
            }.tabViewStyle(PageTabViewStyle())
        }
    }
}

class AppDelegate: NSObject, WKApplicationDelegate {
    // No additional setup required for now
}
