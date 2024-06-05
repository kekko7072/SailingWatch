//
//  SetView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 04/06/24.
//

import SwiftUI

struct SetLineView: View {
    @StateObject var locationManager: LocationManager

    var body: some View {
        VStack {
            Spacer()
            HStack {
                if locationManager.pointALocation != nil {
                    Button{
                        locationManager.pointALocation = locationManager.getCurrentLocation()
                    }label: {
                        Image(systemName: "sailboat")
                    }.buttonStyle(.borderedProminent).tint(.orange)
                } else {
                    Button{
                        locationManager.pointALocation = locationManager.getCurrentLocation()
                    }label: {
                        Image(systemName: "sailboat")
                    }.foregroundStyle(.white).tint(.orange)
                }
                if locationManager.pointBLocation != nil {
                    Button {
                        locationManager.pointBLocation = locationManager.getCurrentLocation()
                    } label: {
                        Image(systemName: "flag.fill")
                    }.buttonStyle(.borderedProminent).tint(.yellow)
                } else {
                    Button {
                        locationManager.pointBLocation = locationManager.getCurrentLocation()
                    } label: {
                        Image(systemName: "flag.fill")
                    }.foregroundStyle(.white).tint(.yellow)
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
    SetLineView(locationManager: LocationManager())
}
