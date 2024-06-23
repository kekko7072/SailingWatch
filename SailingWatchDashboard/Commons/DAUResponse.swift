//
//  DAUResponse.swift
//  SailingWatchDashboard
//
//  Created by Francesco Vezzani on 23/06/24.
//

import Foundation

struct DAUResponse: Decodable {
    let sessions: Int
    let locales: [String: Int]
    let logs: [LogEvent]
}
