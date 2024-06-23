//
//  LogEvent.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import Foundation

struct LogEvent: Decodable, Identifiable {
    let sessionId: String
    let event: String
    let timestamp: Timestamp
    //let data: Any
    let deviceLocalization: String
    
    var id: String {
        sessionId
    }
}

struct Timestamp: Decodable {
    let _seconds: Int
    let _nanoseconds: Int
}

func printTimestamp(_ time: Timestamp) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(time._seconds))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
    return dateFormatter.string(from: date)
}
