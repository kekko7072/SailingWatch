//
//  CountdownTime.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import Foundation

enum CountdownTime: TimeInterval, CaseIterable {
    
    
    case tenMinutes = 600  // 10 * 60 s
    case sixMinutes = 360  // 6 * 60 s
    case fiveMinutes = 300  // 5 * 60 s
    case fourMinutes = 240  // 4 * 60 s
    case threeMinutes = 180 // 3 * 60 s
    case twoMinutes = 120   // 2 * 60 s
    case oneMinute = 60     // 1 * 60 s
    case thirtySeconds = 30 // 30 s
    case twentySeconds = 20 // 20 s
    case fiftheenSeconds = 15 // 15 s
    case tenSeconds = 10 // 10 s
    case fiveSeconds = 5 // 5 s
    
    
    var displayString: String {
        switch self {
        case .tenMinutes: return "10:00"
        case .sixMinutes: return "6:00"
        case .fiveMinutes: return "5:00"
        case .fourMinutes: return "4:00"
        case .threeMinutes: return "3:00"
        case .twoMinutes: return "2:00"
        case .oneMinute: return "1:00"
        case .thirtySeconds: return "0:30"
        case .twentySeconds: return "0:20"
        case .fiftheenSeconds: return "0:15"
        case .tenSeconds: return "0:10"
        case .fiveSeconds: return "0:05"
        }
    }
}
