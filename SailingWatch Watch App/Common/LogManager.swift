//
//  LogManager.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 18/06/24.
//

import Foundation
import CoreLocation

enum EventType: String {
    case appFirstOpen = "App First Open"
    case appLaunched = "App Launched"
    case timerStarted = "Timer Started"
    case timerFinished = "Timer Finished"
    case lineConfigured = "Line Configured"
}

class LogManager {
    static let shared = LogManager()
    private var sessionId: String
    
    private init() {
        self.sessionId = UUID().uuidString
    }
    
    func getDeviceLocalization() -> String {
        return Locale.current.identifier
    }
    
    func logEvent(_ event: EventType, data: [String: String] = [:]) {

        let url = URL(string: "https://us-central1-sailingwatch-app.cloudfunctions.net/api/log-event")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deviceLocalization = getDeviceLocalization()
        let eventLog: [String: Any] = ["sessionId": sessionId, "event": event.rawValue, "data": data, "deviceLocalization": deviceLocalization]
        request.httpBody = try? JSONSerialization.data(withJSONObject: eventLog, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error logging event: \(error)")
                return
            }
            print("Event logged successfully")
        }
        
        task.resume()
    }
}

