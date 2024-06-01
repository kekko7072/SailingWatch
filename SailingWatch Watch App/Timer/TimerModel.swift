import Foundation
import HealthKit
import AVFoundation
import WatchKit

class TimerModel: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    @Published var displayTime: String = "00:00:00"
    @Published var isPaused: Bool = false
    @Published var countdownDuration: TimeInterval = CountdownTime.fiveMinutes.rawValue

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
    
    private func startCountdown() {
        
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
        
        /// Play start haptic
        playHaptic(for: .start)
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
        
        /// Play start haptic
        playHaptic(for: .start)
    }
    
    private func startStopwatch() {
        timer?.invalidate()
        stopwatchStartTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let startTime = self.stopwatchStartTime else { return }
            let elapsedTime = Date().timeIntervalSince(startTime)
            self.displayTime = self.formatTime(elapsedTime)
        }
        
        /// Play start haptic
        playHaptic(for: .start)
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
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
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
        if let interval = soundIntervals.first(where: { $0.time == remainingTime }) {
            switch interval.feedback {
            case .audio(let audioType):
                playAudio(for: audioType)
            case .haptic(let hapticType):
                playHaptic(for: hapticType)
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
