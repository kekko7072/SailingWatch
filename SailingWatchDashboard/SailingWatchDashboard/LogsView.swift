//
//  LogsListView.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import SwiftUI

struct LogsView: View {
    @State private var errorMessage: String?
    @State private var logs: [LogEvent] = []
    
    var body: some View {
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(logs) { logEvent in
                        VStack(alignment: .leading) {
                            Text("Session ID: \(logEvent.sessionId)")
                                .font(.headline)
                            Text("Event: \(logEvent.event)")
                            Text("Timestamp: \(printTimestamp(logEvent.timestamp))")
                            Text("Device Localization: \(logEvent.deviceLocalization)")
                        }
                        .padding()
                    }.navigationTitle("Logs")
                }
            }
                .onAppear {
                    fetchData()
                }
    }
    
    private func fetchData() {
        NetworkManager.shared.fetchDAUData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.logs = data.logs.sorted(by: { a, b in
                        a.timestamp._seconds > b.timestamp._seconds
                    })
                case .failure(let error):
                    self.errorMessage = "Error fetching data: \(error.localizedDescription)"
                }
            }
        }
    }
}


#Preview {
    LogsView()
}
