//
//  GPSView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 01/06/24.
//

import SwiftUI

struct StartView: View {
    @StateObject var locationManager = LocationManager()
    
    @State var settedLine = false
    @State var settedPointA = false
    @State var settedPointB = false
    
    var body: some View {
        NavigationStack {
            if !settedLine {
                VStack {
                    Spacer()
                    HStack {
                        if locationManager.pointALocation != nil {
                            Button("A"){
                                locationManager.pointALocation = locationManager.getCurrentLocation()
                            }.buttonStyle(.borderedProminent).tint(.blue)
                        } else {
                            Button("A"){
                                locationManager.pointALocation = locationManager.getCurrentLocation()
                            }.foregroundStyle(.white).tint(.blue)
                        }
                        if locationManager.pointBLocation != nil {
                            Button("B"){
                                locationManager.pointBLocation = locationManager.getCurrentLocation()
                            }.buttonStyle(.borderedProminent).tint(.red)
                        } else {
                            Button("B"){
                                locationManager.pointBLocation = locationManager.getCurrentLocation()
                            }.foregroundStyle(.white).tint(.red)
                        }
                    }
                    Spacer()
                    if locationManager.pointALocation != nil && locationManager.pointBLocation != nil {
                        Button("READY"){
                            settedLine = true
                        }.buttonStyle(.borderedProminent).tint(.green).bold()
                    }else {
                        Button("READY"){
                            WKInterfaceDevice.current().play(.failure)
                        }.foregroundStyle(.white).tint(.green)
                    }
                    Spacer()
                }.foregroundStyle(.black).bold().onAppear {
                    locationManager.requestAuthorization()
                }.onReceive(locationManager.$liveLocation, perform: { _ in
                    print(locationManager.liveLocation ?? "")
                })
            } else {
                
                VStack {
                    MapView(userLocation: locationManager)
                        .scaledToFill()
                        .cornerRadius(10).disabled(true)
                }.toolbar {
                    if let speed = locationManager.liveLocation?.speed {
                        ToolbarItem(placement: .topBarLeading) {
                            Text("\(speed, specifier: "%.2f") m/s").padding().background(.purple).cornerRadius(10)
                        }
                    }
                        ToolbarItem(placement: .topBarTrailing) {
                            Text("\(locationManager.calculateDistanceFromLine(), specifier: "%.2f") m").padding().background(.teal).cornerRadius(10)
                        }
                    
                    
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button {
                            locationManager.pointALocation = locationManager.getCurrentLocation()
                        } label: {
                            Text("A")
                        }.background(.blue, in: Capsule())
                        
                        Button(action: {
                            WKInterfaceDevice.current().play(.failure)
                            locationManager.lineToSet()
                            settedLine = false
                        }) {
                            Image(systemName:"xmark")
                        }
                        .controlSize(.large)
                        .background(.orange, in: Capsule())
                        
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
    StartView().environmentObject(LocationManager())
}
