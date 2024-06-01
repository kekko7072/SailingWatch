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
    var time: TimeInterval
    var feedback: FeedbackType
    
    init(time: TimeInterval, feedback: FeedbackType) {
        self.time = time
        self.feedback = feedback
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
