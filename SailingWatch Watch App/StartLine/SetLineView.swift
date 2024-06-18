//
//  SetView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 04/06/24.
//

import SwiftUI
import TipKit

struct SetLineView: View {
    @StateObject var locationManager: LocationManager
    
    var  tipSetPointAB = TipSetPointAB()
    var  tipSetLine = TipSetLine()
    
    
    var body: some View {
        VStack {
            Spacer()
            TipView(tipSetPointAB, arrowEdge: .bottom).tipViewStyle(MyTipStyle())
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
                    }.foregroundStyle(.orange).tint(.orange)
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
                    }.foregroundStyle(.yellow).tint(.yellow)
                }
            }
            Spacer()
            TipView(tipSetLine, arrowEdge: .bottom).tipViewStyle(MyTipStyle())
            if locationManager.pointALocation != nil && locationManager.pointBLocation != nil {
                Button("LINE"){
                    locationManager.lineSet()
                    
                    /// Log event - Line configured
                    LogManager.shared.logEvent(.lineConfigured)
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
        }).task {
            // Configure and load your tips at app launch.
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    }
}

#Preview {
    SetLineView(locationManager: LocationManager())
}
