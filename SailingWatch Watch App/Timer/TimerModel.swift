import Foundation
import SwiftUI
import HealthKit
import AVFoundation
import WatchKit

class TimerModel: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    @Published var displayTime: (String, Font) = ("00:00:00", .largeTitle)
    @Published var isPaused: Bool = false
    @Published var countdownDuration: TimeInterval = CountdownTime.fiveMinutes.rawValue
    @Published var heartRate: Double = 0.0
    @Published var isCountingDown: Bool = true
    
    private var remainingTime: TimeInterval?
    private var stopwatchStartTime: Date?
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?
    
    private let healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    override init() {
        super.init()
        configureAudioSession()
        /// Initialise display time with the initial value of countdownDuration
        self.displayTime = self.formatTime(countdownDuration)
    }
    
    func requestAuthorization() {
        let typesToShare: Set = [HKQuantityType.workoutType()]
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if !success {
                // Handle error
            }
        }
    }
    
    func start() {
        if isPaused, let remainingTime = remainingTime {
            resumeCountdown(from: remainingTime)
        } else {
            startWorkoutSession()
            startCountdown()
            startHeartRateQuery()
        }
        
        /// Play start haptic
        playHaptic(for: .start)
    }
    
    func pause() {
        timer?.invalidate()
        isPaused = true
        
        /// Play start haptic
        playHaptic(for: .stop)
    }
    
    func stop() {
        stopWorkoutSession()
        timer?.invalidate()
        isPaused = false
        remainingTime = nil
        
        /// Play start haptic
        playHaptic(for: .failure)
    }
    
    func syncToNextInterval() {
        guard let remainingTime = remainingTime else { return }
        if let nextInterval = soundIntervals.first(where: { $0.time < Int(remainingTime) }) {
            self.remainingTime = nextInterval.toTime()
            self.displayTime = self.formatTime(nextInterval.toTime())
            timer?.invalidate()
            if(!isPaused){
                resumeCountdown(from: nextInterval.toTime())
            }
        }
        /// Play start haptic
        playHaptic(for: .retry)
    }
    
    private func startCountdown() {
        self.isCountingDown = true
        remainingTime = countdownDuration
        let endTime = Date().addingTimeInterval(countdownDuration)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let currentTime = Date()
            if currentTime >= endTime {
                self.startStopwatch()
            } else {
                let remainingTime = endTime.timeIntervalSince(currentTime)
                self.remainingTime = remainingTime
                self.displayTime = self.formatTime(remainingTime)
                self.checkFeedback(for: remainingTime)
            }
        }
    }
    
    private func resumeCountdown(from time: TimeInterval) {
        let endTime = Date().addingTimeInterval(time)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let currentTime = Date()
            if currentTime >= endTime {
                self.startStopwatch()
            } else {
                let remainingTime = endTime.timeIntervalSince(currentTime)
                self.remainingTime = remainingTime
                self.displayTime = self.formatTime(remainingTime)
                self.checkFeedback(for: remainingTime)
            }
        }
        isPaused = false
    }
    
    private func startStopwatch() {
        self.isCountingDown = false
        timer?.invalidate()
        stopwatchStartTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let startTime = self.stopwatchStartTime else { return }
            let elapsedTime = Date().timeIntervalSince(startTime)
            self.displayTime = self.formatTime(elapsedTime)
            self.checkFeedback(for: -elapsedTime)
        }
    }
    
    private func startWorkoutSession() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .sailing
        configuration.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = workoutSession?.associatedWorkoutBuilder()
            workoutSession?.delegate = self
            builder?.delegate = self
            
            workoutSession?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date(), completion: { success, error in
                if !success {
                    // Handle error
                }
            })
        } catch {
            // Handle error
        }
    }
    
    private func stopWorkoutSession() {
        workoutSession?.end()
    }
    
    /// Public to make changable the initial value also on CounterView
    func formatTime(_ time: TimeInterval) -> (String, Font) {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        
        if hours > 0 {
            return (String(format: "%02d:%02d:%02d", hours, minutes, seconds), .largeTitle)
        }else{
            return (String(format: "%02d:%02d", minutes, seconds),.system(size: 60))
        }
    }
    
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            // Handle error
        }
    }
    
    private func playAudio(for audioType: AudioType) {
        guard let soundURL = Bundle.main.url(forResource: audioType.rawValue, withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            // Handle error
        }
    }
    
    private func playHaptic(for hapticType: WKHapticType) {
        WKInterfaceDevice.current().play(hapticType)
    }
    
    private func checkFeedback(for remainingTime: TimeInterval) {
        if let interval = soundIntervals.first(where: { $0.time == Int(remainingTime) }) {
            switch interval.feedback {
            case .audio(let audioType):
                playAudio(for: audioType)
            case .haptic(let hapticType):
                playHaptic(for: hapticType)
            }
        }
    }
    
    private func startHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let datePredicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictStartDate)
        
        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: datePredicate, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples)
        }
        
        heartRateQuery.updateHandler = { [weak self] query, samples, deletedObjects, anchor, error in
            self?.processHeartRateSamples(samples)
        }
        
        healthStore.execute(heartRateQuery)
    }
    
    private func processHeartRateSamples(_ samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample] else { return }
        
        DispatchQueue.main.async {
            if let lastSample = heartRateSamples.last {
                self.heartRate = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }
    }
    
    // MARK: - HKWorkoutSessionDelegate
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Handle error
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        // Handle event
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        // Handle state changes
    }
    
    // MARK: - HKLiveWorkoutBuilderDelegate
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Handle collected events
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        // Handle collected data
    }
}
