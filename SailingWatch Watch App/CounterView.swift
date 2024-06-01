import SwiftUI
import WatchKit
import HealthKit

struct ContentView: View {
    @StateObject private var timerModel = TimerModel()
    @State private var isStarted = false
    @State private var selectedDuration = CountdownTime.fiveMinutes
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if isStarted || timerModel.isPaused  {
                    Text(timerModel.displayTime)
                        .font(.largeTitle)
                        .padding()
                }else{
                    Picker(selection: $selectedDuration, label: Text("Select Duration")) {
                        ForEach(CountdownTime.allCases, id: \.self) { duration in
                            Text(duration.displayString).font(.title).tag(duration)
                        }
                    }
                    .onChange(of: selectedDuration) { oldValue, newValue in
                        timerModel.countdownDuration = newValue.rawValue
                    }
                    .padding().padding(.bottom, 10)
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Perform an action here.
                    } label: {
                        Image(systemName:"suit.heart")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Perform an action here.
                    } label: {
                        Image(systemName:"suit.club")
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    if isStarted || timerModel.isPaused {
                        Button {
                            // Perform an action here.
                        } label: {
                            Image(systemName:"arrow.triangle.2.circlepath")
                        }
                    }else{
                        Spacer()
                    }
                    
                    if isStarted {
                        Button(action: {
                            timerModel.pause()
                            isStarted = false
                        }) {
                            Image(systemName:"pause")
                        }.controlSize(.large)
                            .background(.orange, in: Capsule())
                    } else if timerModel.isPaused {
                        Button(action: {
                            timerModel.start()
                            isStarted = true
                        }) {
                            Image(systemName:"playpause")
                        }
                        .controlSize(.large)
                        .background(.green, in: Capsule())
                    } else {
                        Button(action: {
                            timerModel.start()
                            isStarted = true
                        }) {
                            Image(systemName:"play")
                        }
                        .controlSize(.large)
                        .background(.green, in: Capsule())
                    }
                    
                    if isStarted || timerModel.isPaused {
                        Button(action: {
                            timerModel.stop()
                            isStarted = false
                        }) {
                            Image(systemName:"stop")
                        }
                    }else{
                        Spacer()
                    }
                }
            }
            .onAppear {
                timerModel.requestAuthorization()
            }
        }
    }
}

#Preview {
    ContentView()
}
