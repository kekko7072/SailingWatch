//
//  GPSSelectionView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 10/09/23.
//

import SwiftUI

struct GPSSelectionView: View {
    @EnvironmentObject var locationViewModel: LocationManager
    @State var settedPointA = false
    @State var settedPointB = false
    
    var body: some View {
            VStack {
                /*HStack {
                    Text("Speed: ")
                    Text("\(locationViewModel.liveLocation?.speed ?? 0, specifier:"%.3f")").foregroundStyle(.green)
                }*/
                Spacer()
                HStack {
                    if locationViewModel.pointALocation != nil {
                        Button("A"){
                            locationViewModel.pointALocation = locationViewModel.getCurrentLocation()
                        }.buttonStyle(.borderedProminent).tint(.blue)
                    } else {
                        Button("A"){
                            locationViewModel.pointALocation = locationViewModel.getCurrentLocation()
                        }.tint(.blue)
                    }
                    if locationViewModel.pointBLocation != nil {
                        Button("B"){
                            locationViewModel.pointBLocation = locationViewModel.getCurrentLocation()
                        }.buttonStyle(.borderedProminent).tint(.red)
                    } else {
                        Button("B"){
                            locationViewModel.pointBLocation = locationViewModel.getCurrentLocation()
                        }.tint(.red)
                    }
                }
               Spacer()
                if locationViewModel.pointALocation != nil && locationViewModel.pointBLocation != nil {
                    Button("Ready"){
                            locationViewModel.lineReady()
                    }.buttonStyle(.borderedProminent).tint(.green)
                }else {
                    Button("Ready"){
                            WKInterfaceDevice.current().play(.failure)
                    }.tint(.green)
                }
                Spacer()
                
                /*if locationViewModel.liveLocation != nil {
                    Text("Distance: \(locationViewModel.pointALocation?.distance(from: locationViewModel.liveLocation!) ?? 0)")
                }*/
            }.onAppear {
                locationViewModel.requestAuthorization()
            }.onReceive(locationViewModel.$liveLocation, perform: { _ in
                print(locationViewModel.liveLocation ?? "")
            })
            
    }
}

struct GPSSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GPSSelectionView()
    }
}
