//
//  GPSSelectorView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 10/09/23.
//

import SwiftUI

struct GPSWrapperView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        switch locationManager.locationStatus {
        case .notDetermined:
            AnyView(GPSRequestView())
                .environmentObject(locationManager)
        case .restricted:
            GPSErrorView(errorText: "Location use is restricted.")
        case .denied:
            GPSErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            if locationManager.state == LocationMode.selection {
                GPSSelectionView().environmentObject(locationManager)
            } else {
                GPSActiveView().environmentObject(locationManager)
            }
        default:
            Text("Unexpected status")
        }
    }
}

struct GPSSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        GPSWrapperView().environmentObject(LocationManager())
    }
}
