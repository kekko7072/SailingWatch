//
//  SetView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 04/06/24.
//

import SwiftUI

struct SetView: View {
    @StateObject var locationManager: LocationManager

    var body: some View {
        VStack {
            Spacer()
            HStack {
                if locationManager.pointALocation != nil {
                    Button("A"){
                        locationManager.pointALocation = locationManager.getCurrentLocation()
                    }.buttonStyle(.borderedProminent).tint(.orange)
                } else {
                    Button("A"){
                        locationManager.pointALocation = locationManager.getCurrentLocation()
                    }.foregroundStyle(.white).tint(.orange)
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
                Button("LINE"){
                    locationManager.lineSet()
                }.buttonStyle(.borderedProminent).tint(.green).bold()
            }else {
                Button("LINE"){
                    WKInterfaceDevice.current().play(.failure)
                }.foregroundStyle(.white).tint(.green)
            }
            Spacer()
        }.font(.title2).foregroundStyle(.black).bold().onAppear {
            locationManager.requestAuthorization()
        }.onReceive(locationManager.$liveLocation, perform: { _ in
            print(locationManager.liveLocation ?? "")
        })
    }
}

#Preview {
    SetView(locationManager: LocationManager())
}
