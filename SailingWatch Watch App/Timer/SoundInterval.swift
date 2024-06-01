//
//  SoundInterval.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import Foundation
import WatchKit

enum AudioType: String {
    case start = "start"
    case count = "count"
}

enum FeedbackType {
    case audio(AudioType)
    case haptic(WKHapticType)
}

class SoundInterval {
    var time: Int
    var feedback: FeedbackType
    
    init(time: Int, feedback: FeedbackType) {
        self.feedback = feedback
        
        switch feedback {
        case .audio(let audioType):
            /// This latecny it's necessary to make sure audio it's played at the correct time
            /// due to latency in audio playing from AVAudio
            self.time = time + 3
        case .haptic(let wKHapticType):
            self.time = time
        }
    }
    
    public func toTime() -> TimeInterval {
        switch self.feedback {
        case .audio(let audioType):
            /// This to remove latency when displaying and sync time
            return TimeInterval(self.time - 3)
        case .haptic(let wKHapticType):
            return TimeInterval(self.time)
        }
        
    }
}

let soundIntervals: [SoundInterval] = [
    SoundInterval(time: 240, feedback: .audio(.count)),
    SoundInterval(time: 120, feedback: .audio(.count)),
    SoundInterval(time: 60, feedback: .audio(.count)),
    SoundInterval(time: 50, feedback: .haptic(.success)),
    SoundInterval(time: 40, feedback: .haptic(.success)),
    SoundInterval(time: 30, feedback: .haptic(.success)),
    SoundInterval(time: 20, feedback: .haptic(.success)),
    SoundInterval(time: 15, feedback: .haptic(.success)),
    SoundInterval(time: 10, feedback: .haptic(.success)),
    SoundInterval(time: 5, feedback: .haptic(.success)),
    SoundInterval(time: 4, feedback: .haptic(.success)),
    SoundInterval(time: 3, feedback: .haptic(.success)),
    SoundInterval(time: 2, feedback: .haptic(.success)),
    SoundInterval(time: 1, feedback: .haptic(.success)),
    SoundInterval(time: 0, feedback: .haptic(.failure)),
]
