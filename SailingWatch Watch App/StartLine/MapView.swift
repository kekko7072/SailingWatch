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
    
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion())

    var body: some View {
        VStack {
            Map(position: $cameraPosition) {
                
                MapPolyline(coordinates: coordinates(userLocation)).stroke(.green, lineWidth: 8)
                
                ForEach(annotations(userLocation)) { annotation in
                    MapCircle(center: annotation.coordinate, radius: CLLocationDistance(4))
                        .foregroundStyle(annotation.tint)
                        .mapOverlayLevel(level: .aboveLabels)
                }
                
                UserAnnotation()
                
            }.edgesIgnoringSafeArea(.all)
        }.onAppear {
            setRegion(for: coordinates(userLocation))
        }.onChange(of: userLocation.pointALocation) { _, _ in
            setRegion(for: coordinates(userLocation))
        }.onChange(of: userLocation.pointBLocation) { _, _ in
            setRegion(for: coordinates(userLocation))
        }
    }
    
    private func annotations(_ userLocation: LocationManager) -> [PointAnnotation] {
           var points = [PointAnnotation]()
           if let pointA = userLocation.pointALocation {
               points.append(PointAnnotation(coordinate: pointA.coordinate, tint: .orange, title: "A"))
           }
           if let pointB = userLocation.pointBLocation {
               points.append(PointAnnotation(coordinate: pointB.coordinate, tint: .red, title: "B"))
           }
           return points
       }
       
       private func coordinates(_ userLocation: LocationManager) -> [CLLocationCoordinate2D] {
           var coordinates = [CLLocationCoordinate2D]()
           if let pointA = userLocation.pointALocation {
               coordinates.append(pointA.coordinate)
           }
           if let pointB = userLocation.pointBLocation {
               coordinates.append(pointB.coordinate)
           }
           return coordinates
       }
    
    private func setRegion(for coordinates: [CLLocationCoordinate2D]) {
        guard !coordinates.isEmpty else { return }
        
        var minLat = coordinates.first?.latitude ?? 0
        var maxLat = coordinates.first?.latitude ?? 0
        var minLon = coordinates.first?.longitude ?? 0
        var maxLon = coordinates.first?.longitude ?? 0
        
        for coordinate in coordinates {
            if coordinate.latitude < minLat {
                minLat = coordinate.latitude
            }
            if coordinate.latitude > maxLat {
                maxLat = coordinate.latitude
            }
            if coordinate.longitude < minLon {
                minLon = coordinate.longitude
            }
            if coordinate.longitude > maxLon {
                maxLon = coordinate.longitude
            }
        }
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        let spanLat = maxLat - minLat
        let spanLon = maxLon - minLon
        
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        let span = MKCoordinateSpan(latitudeDelta: spanLat * 1.2, longitudeDelta: spanLon * 1.2) // Adding some padding
        
        let region = MKCoordinateRegion(center: center, span: span)
        self.cameraPosition = .region(region)
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
