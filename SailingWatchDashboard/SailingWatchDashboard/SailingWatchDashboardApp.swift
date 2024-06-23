//
//  SailingWatchDashboardApp.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import SwiftUI

@main
struct SailingWatchDashboardApp: App {
    var body: some Scene {
        WindowGroup {TabView{
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
        }
    }
}
