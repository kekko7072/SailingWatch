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
    @ObservedObject var locationManager: LocationManager
    
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
                    }else{
                        HStack{
                            if(timerModel.isPaused){
                                Button(action: {
                                    timerModel.stop()
                                    isStarted = false
                                }) {
                                    Image(systemName: "stop").bold().foregroundStyle(.black)
                                }.buttonStyle(.borderedProminent).tint(.red)
                                Button(action: {
                                    timerModel.start()
                                }) {
                                    Image(systemName: "play").bold().foregroundStyle(.black)
                                }.buttonStyle(.borderedProminent).tint(.green)
                            }else{
                                Button(action: {
                                    timerModel.syncToNextInterval()
                                }) {
                                    Image(systemName: "arrow.triangle.2.circlepath").bold().foregroundStyle(.black)
                                }.buttonStyle(.borderedProminent).tint(.blue)
                                Button(action: {
                                    timerModel.pause()
                                }) {
                                    Image(systemName: "pause").bold().foregroundStyle(.black)
                                }.buttonStyle(.borderedProminent).tint(.orange)
                            }
                        }
                    }
                }else{
                    Picker(selection: $selectedDuration, label: EmptyView()) {
                        ForEach(CountdownTime.allCases, id: \.self) { duration in
                            let isSelected = selectedDuration == duration
                            Text(duration.displayString).font(isSelected ? .largeTitle : .title2).tag(duration).foregroundStyle(isSelected ? .green : .white).fontWeight(isSelected ? .bold :.regular)
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
                        Text("START").font(.title2).foregroundStyle(.black).bold()
                    }.buttonStyle(.borderedProminent).tint(.green)
                    
                }
            }.toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if(locationManager.lineConfigured){
                        Text("\(locationManager.calculateDistanceFromLine()/timerModel.speed, specifier: "%.0f") m/s")
                    }else{
                        Text("\(timerModel.speed, specifier: "%.0f") m/s")
                    }
                }
                if isStarted || timerModel.isPaused {
                    ToolbarItem(placement: .topBarTrailing) {
                        if(locationManager.lineConfigured){
                            Text("\(locationManager.calculateDistanceFromLine(), specifier: "%.0f") m")
                        }else{
                            HStack{
                                Text(String(format: "%.0f", timerModel.heartRate))
                                Image(systemName: "heart")
                            }
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
    TimerView(locationManager: LocationManager())
}
