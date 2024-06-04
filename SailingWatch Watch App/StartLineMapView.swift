//
//  GPSView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import SwiftUI

struct StartLineMapView: View {
    @ObservedObject var locationManager: LocationManager
    @StateObject private var networkMonitor = NetworkMonitor()
    
    
    var body: some View {
        NavigationStack {
            if !locationManager.lineConfigured {
                SetView(locationManager: locationManager)
            } else {
                VStack {
                    if networkMonitor.isConnected {
                        MapView(userLocation: locationManager)
                            .scaledToFill()
                            .cornerRadius(10).disabled(true)
                    } else {
                        PositionView(userLocation: locationManager)
                            .scaledToFill()
                            .cornerRadius(10)
                    }
                }.toolbar {
                    if let speed = locationManager.liveLocation?.speed {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("\(speed, specifier: "%.2f") m/s").padding().background(.teal).cornerRadius(10)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("\(locationManager.calculateDistanceFromLine(), specifier: "%.2f") m").foregroundStyle(.black).padding().background(.yellow).cornerRadius(10)
                    }
                    
                    
                    
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
    StartLineMapView(locationManager: LocationManager())
}
