//
//  StartLineDataView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 04/06/24.
//

import SwiftUI

struct StartLineDataView: View {
    @ObservedObject var locationManager: LocationManager
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        NavigationStack {
            if !locationManager.lineConfigured {
                SetLineView(locationManager: locationManager)
            } else {
                VStack {
                    HStack{
                        if let speed = locationManager.liveLocation?.speed {
                            Text("\(locationManager.calculateDistanceFromLine()/speed, specifier: "%.0f") s")
                        }
                        Spacer()
                        Text("\(locationManager.calculateDistanceFromLine(), specifier: "%.0f") m")
                    }
                    HStack{
                        if let speed = locationManager.liveLocation?.speed {
                            Text("\(speed, specifier: "%.0f") m/s")
                        }
                        Spacer()
                        if let course = locationManager.liveLocation?.course {
                            Text("\(course, specifier: "%.0f") °")
                        }
                    }
                }.font(.title).bold().toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            locationManager.pointALocation = locationManager.getCurrentLocation()
                        } label: {
                            Image(systemName: "sailboat").foregroundStyle(.black)
                        }.background(.orange, in: Capsule()).tint(.orange)
                        
                        Button(action: {
                            WKInterfaceDevice.current().play(.failure)
                            locationManager.lineToSet()
                        }) {
                            Image(systemName:"xmark").foregroundStyle(.black)
                        }
                        .controlSize(.large)
                        .background(.red, in: Capsule()).tint(.red)
                        
                        Button {
                            locationManager.pointBLocation = locationManager.getCurrentLocation()
                        } label: {
                            Image(systemName: "flag.fill").foregroundStyle(.black)
                        }.background(.yellow, in: Capsule()).tint(.yellow)
                    }
                }
            }
            
        }
    }
}

#Preview {
    StartLineDataView(locationManager: LocationManager())
}
