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
                SetLineView(locationManager: locationManager)
            } else {
                VStack {
                    MapView(userLocation: locationManager)
                        .scaledToFill()
                        .cornerRadius(10).disabled(true)
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
    StartLineMapView(locationManager: LocationManager())
}
