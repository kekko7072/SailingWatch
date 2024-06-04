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
                SetView(locationManager: locationManager)
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
                }.font(.title3).toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            locationManager.pointALocation = locationManager.getCurrentLocation()
                        } label: {
                            Text("A")
                        }.background(.orange, in: Capsule())
                        
                        Button(action: {
                            WKInterfaceDevice.current().play(.failure)
                            locationManager.lineToSet()
                        }) {
                            Image(systemName:"xmark")
                        }
                        .controlSize(.large)
                        .background(.green, in: Capsule())
                        
                        Button {
                            locationManager.pointBLocation = locationManager.getCurrentLocation()
                        } label: {
                            Text("B")
                        }.background(.red, in: Capsule())
                    }
                }
            }
            
        }
    }
}

#Preview {
    StartLineDataView(locationManager: LocationManager())
}
