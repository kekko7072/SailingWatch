//
//  LogsListView.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import SwiftUI

struct LogsListView: View {
    var logEvents: [LogEvent]

    var body: some View {
        List(logEvents) { logEvent in
            VStack(alignment: .leading) {
                Text("Session ID: \(logEvent.sessionId)")
                    .font(.headline)
                Text("Event: \(logEvent.event)")
                Text("Timestamp: \(printTimestamp(logEvent.timestamp))")
                Text("Device Localization: \(logEvent.deviceLocalization)")
            }
            .padding()
        }
        .navigationTitle("Logs")
    }
}


#Preview {
    LogsListView(logEvents: [])
}
