//
//  SoundInterval.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import Foundation
import WatchKit

enum AudioType: String {
    // MARK: Start sound
    /// Duration: 5 s
    case start = "start"
    /// Duration: 0.5 s
    case startFast = "start_fast"
    
    // MARK: Count sound
    /// Duration: 1 s
    case count = "count"
    /// Duration: 0.5 s
    case countFast = "count_fast"
}

enum FeedbackType {
    case audio(AudioType)
    case haptic(WKHapticType)
}

class SoundInterval {
    var time: Int
    var feedback: FeedbackType
    var enableWaterLock: Bool
    
    init(time: Int, feedback: FeedbackType, enableWaterLock:Bool = false) {
        self.feedback = feedback
        self.time = time
        self.enableWaterLock = enableWaterLock
    }
    
    public func toTime() -> TimeInterval {
        return TimeInterval(self.time)
    }
}

let soundIntervals: [SoundInterval] = [
    // MARK: Count Down values
    SoundInterval(time: 540, feedback: .audio(.count)),
    SoundInterval(time: 480, feedback: .audio(.count)),
    SoundInterval(time: 420, feedback: .audio(.count)),
    SoundInterval(time: 360, feedback: .audio(.count)),
    SoundInterval(time: 300, feedback: .audio(.count)),
    SoundInterval(time: 240, feedback: .audio(.count)),
    SoundInterval(time: 120, feedback: .audio(.count)),
    SoundInterval(time: 60, feedback: .audio(.count)),
    SoundInterval(time: 50, feedback: .audio(.countFast)),
    SoundInterval(time: 40, feedback: .audio(.countFast)),
    SoundInterval(time: 30, feedback: .audio(.countFast)),
    SoundInterval(time: 20, feedback: .audio(.countFast)),
    SoundInterval(time: 15, feedback: .audio(.countFast)),
    SoundInterval(time: 10, feedback: .audio(.countFast)),
    SoundInterval(time: 5, feedback: .audio(.startFast)),
    SoundInterval(time: 4, feedback: .audio(.startFast)),
    SoundInterval(time: 3, feedback: .audio(.startFast)),
    SoundInterval(time: 2, feedback: .audio(.startFast)),
    SoundInterval(time: 1, feedback: .audio(.startFast)),
    SoundInterval(time: 0, feedback: .audio(.start)),
    // MARK: Count Up values
    SoundInterval(time: -1, feedback: .haptic(.success)),
    SoundInterval(time: -2, feedback: .haptic(.success)),
    SoundInterval(time: -3, feedback: .haptic(.success)),
    SoundInterval(time: -4, feedback: .haptic(.success)),
    SoundInterval(time: -5, feedback: .haptic(.success)),
    SoundInterval(time: -6, feedback: .haptic(.success)),
    SoundInterval(time: -7, feedback: .haptic(.success)),
    SoundInterval(time: -8, feedback: .haptic(.success)),
    SoundInterval(time: -9, feedback: .haptic(.success)),
    SoundInterval(time: -10, feedback: .haptic(.success)),
    SoundInterval(time: -11, feedback: .haptic(.failure)),
    SoundInterval(time: -12, feedback: .haptic(.failure)),
    SoundInterval(time: -13, feedback: .haptic(.failure)),
    SoundInterval(time: -14, feedback: .haptic(.failure)),
    SoundInterval(time: -15, feedback: .haptic(.failure), enableWaterLock: true),
]
