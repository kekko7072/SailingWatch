//
//  TimerView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import SwiftUI
import WatchKit
import HealthKit

struct TimerView: View {
    @StateObject private var timerModel = TimerModel()
    @State private var isStarted = false
    @State private var selectedDuration = CountdownTime.fiveMinutes
    
    
    var body: some View {
        NavigationStack {
            VStack {
                if isStarted || timerModel.isPaused  {
                    Text(timerModel.displayTime.0)
                        .font(timerModel.displayTime.1).bold()
                        .padding()
                    if(!timerModel.isCountingDown){
                        
                        Button(action: {
                            timerModel.stop()
                            isStarted = false
                        }) {
                            Text("FINISH").bold().foregroundStyle(.black)
                        }.buttonStyle(.borderedProminent).tint(.red)
                        
                    }
                }else{
                    Picker(selection: $selectedDuration, label: EmptyView()) {
                        ForEach(CountdownTime.allCases, id: \.self) { duration in
                            let isSelected = selectedDuration == duration
                            Text(duration.displayString).font(isSelected ? .largeTitle : .title2).tag(duration).foregroundStyle(isSelected ? .green : .white)
                        }
                    }
                    .onChange(of: selectedDuration) { oldValue, newValue in
                        timerModel.countdownDuration = newValue.rawValue
                        timerModel.displayTime = timerModel.formatTime(newValue.rawValue)
                    }
                    .padding()
                    
                    Button(action: {
                        timerModel.start()
                        isStarted = true
                    }) {
                        Text("START").foregroundStyle(.black).bold()
                    }.buttonStyle(.borderedProminent).tint(.green)
                    
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("\(timerModel.speed, specifier: "%.0f") m/s")
                }
                if isStarted || timerModel.isPaused {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack{
                            Text(String(format: "%.0f", timerModel.heartRate))
                            Image(systemName: "heart")
                        }
                    }
                    /*ToolbarItem(placement: .topBarTrailing) {
                     Button {
                     // Perform an action here.
                     } label: {
                     Image(systemName:"suit.club")
                     }
                     }*/
                    if timerModel.isCountingDown {
                        ToolbarItemGroup(placement: .bottomBar) {
                            
                            Button {
                                timerModel.syncToNextInterval()
                            } label: {
                                Image(systemName:"arrow.triangle.2.circlepath")
                            }.background(.blue, in: Capsule())
                            
                            
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
                            }
                            
                            Button(action: {
                                timerModel.stop()
                                isStarted = false
                            }) {
                                Image(systemName:"stop")
                            }.background(.red, in: Capsule())
                        }
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
    TimerView()
}
