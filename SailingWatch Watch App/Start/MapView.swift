//
//  MapView.swift
//  SailingWatch Watch App
//
//  Edited by Francesco Vezzani on 01/06/24.
//

import SwiftUI
import MapKit

let defaultCoordinate = CLLocationCoordinate2D(latitude: 42.22, longitude: 12.21)

struct MapView: View {
    @StateObject var userLocation = LocationManager()
    
    var body: some View {
        VStack {
            Map {
                MapPolyline(coordinates: coordinates).stroke(.green, lineWidth: 8)
                
                ForEach(annotations) { annotation in
                    MapCircle(center: annotation.coordinate, radius: CLLocationDistance(8))
                        .foregroundStyle(annotation.tint)
                        .mapOverlayLevel(level: .aboveLabels)
                }
                
                if let live = userLocation.liveLocation?.coordinate {
                    MapCircle(center: live, radius: 10)
                        .foregroundStyle(.yellow)
                        .mapOverlayLevel(level: .aboveLabels)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var annotations: [PointAnnotation] {
        var points = [PointAnnotation]()
        if let pointA = userLocation.pointALocation {
            points.append(PointAnnotation(coordinate: pointA.coordinate, tint: .blue, title: "A"))
        }
        if let pointB = userLocation.pointBLocation {
            points.append(PointAnnotation(coordinate: pointB.coordinate, tint: .red, title: "B"))
        }
        return points
    }
    
    private var coordinates: [CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        if let pointA = userLocation.pointALocation {
            coordinates.append(pointA.coordinate)
        }
        if let pointB = userLocation.pointBLocation {
            coordinates.append(pointB.coordinate)
        }
        return coordinates
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
