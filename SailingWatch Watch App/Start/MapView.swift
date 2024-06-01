//
//  MapView.swift
//  SailingWatch Watch App
//
//  Edited by Francesco Vezzani on 01/06/24.
//

import SwiftUI
import MapKit
import CoreLocation

let defaultCoordinate = CLLocationCoordinate2D(latitude: 42.22, longitude: 12.21)

struct MapView: View {
    @StateObject var userLocation = LocationManager()
    
    var body: some View {
        Map(
            coordinateRegion: .constant(MKCoordinateRegion(
                center: userLocation.liveLocation?.coordinate ?? defaultCoordinate,
                latitudinalMeters: 250,
                longitudinalMeters: 250)
            ),
            showsUserLocation: true,
            userTrackingMode: .constant(.follow),
            annotationItems: annotations
        ) { annotation in
            MapMarker(coordinate: annotation.coordinate, tint: annotation.tint)
        }
    }
    
    private var annotations: [PointAnnotation] {
        var points = [PointAnnotation]()
        if let pointA = userLocation.pointALocation {
            points.append(PointAnnotation(coordinate: pointA.coordinate, tint: .blue, title: "Point A"))
        }
        if let pointB = userLocation.pointBLocation {
            points.append(PointAnnotation(coordinate: pointB.coordinate, tint: .blue, title: "Point B"))
        }
        return points
    }
}

struct PointAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
    let title: String?
}

#Preview {
    MapView()
}
