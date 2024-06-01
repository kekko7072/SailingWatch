//
//  GPSMapView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 10/09/23.
//

import SwiftUI
import MapKit
import CoreLocation

var LAT_USER = 42.22
var LNG_USER = 12.21

var LAT_LINE = 46.57589
var LNG_LINE_A = 12.39095
var LNG_LINE_B = 12.392

struct GPSActiveView: View {
    @EnvironmentObject var userLocation: LocationManager
    @State var disableTouch = true
    var body: some View {
        
            //Text("User Location: \(userLocation.liveLocation?.coordinate.latitude ?? 0), \(userLocation.liveLocation?.coordinate.longitude ?? 0)")
            VStack {
                MapView(userLocation: userLocation)
                    .scaledToFill()
                    .cornerRadius(10).padding().disabled(disableTouch)
                HStack{
                    Spacer()
                    Button(action: {
                        WKInterfaceDevice.current().play(.failure)
                        userLocation.lineToSet()
                    }, label: {
                        Text("RESET").font(.subheadline.weight(.bold)).foregroundColor(.black)
                    }).buttonStyle(.borderedProminent)
                        .tint(.red).padding(.horizontal)
                    Spacer()
                }.padding(.bottom)
            }
        }
}

struct MapView: View {
    var userLocation: LocationManager
    
    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: userLocation.liveLocation?.coordinate ?? CLLocationCoordinate2D(latitude: LAT_USER, longitude: LNG_USER), latitudinalMeters: 250, longitudinalMeters: 250)), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [
            PointAnnotation(coordinate: userLocation.pointALocation!.coordinate , tint: .blue, title: "Point A"),
            PointAnnotation(coordinate: userLocation.pointBLocation?.coordinate ?? CLLocationCoordinate2D(latitude: LAT_USER, longitude: LNG_USER), tint: .blue, title: "Point B"),
        ]) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: annotation.tint)
        }
    }
}

struct PointAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
    let title: String?
}

struct GPSMapView_Previews: PreviewProvider {
    static var previews: some View {
        GPSActiveView()
    }
}
