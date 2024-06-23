//
//  SailingWatchDashboardApp.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import SwiftUI

@main
struct SailingWatchDashboardApp: App {
    @State private var selectedSession = true
    var body: some Scene {
        WindowGroup {
            if(UIDevice.current.userInterfaceIdiom == .phone){
                TabView{
                    NavigationView{
                        SessionsView()
                    }.tabItem {
                        Label {
                            Text("Sessions")
                        } icon: {
                            Image(systemName:"chart.pie")
                        }
                    }
                    NavigationView{
                        LogsView()
                    }.tabItem {
                        Label {
                            Text("Logs")
                        } icon: {
                            Image(systemName: "list.bullet.rectangle")
                        }
                    }
                }
            }else{
                NavigationSplitView {
                    List {
                        Label(
                            title: { Text("Sessions") },
                            icon: { Image(systemName: "chart.pie") }
                        ).foregroundStyle( selectedSession ? Color.accentColor: .secondary).onTapGesture {
                            selectedSession = true
                        }
                        Label(
                            title: { Text("Logs") },
                            icon: { Image(systemName: "list.bullet.rectangle") }
                        ).foregroundStyle( !selectedSession ? Color.accentColor: .secondary).onTapGesture {
                            selectedSession = false
                        }
                    }.navigationTitle("Dashboard")
                } detail: {
                    NavigationStack {
                        if selectedSession {
                            SessionsView()
                        }else{
                            LogsView()
                        }
                    }
                }
            }
        }
    }
}
