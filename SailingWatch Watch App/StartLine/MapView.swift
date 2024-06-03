//
//  MapView.swift
//  SailingWatch Watch App
//
//  Edited by Francesco Vezzani on 01/06/24.
//

import SwiftUI
import MapKit


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
            updateCameraPosition()
        }.onChange(of: userLocation.pointALocation) { _, _ in
            updateCameraPosition()
        }.onChange(of: userLocation.pointBLocation) { _, _ in
            updateCameraPosition()
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
    
    private func updateCameraPosition() {
        let coords = coordinates(userLocation)
        setRegion(for: coords)
        
        if coords.count == 2 {
            let angle = calculateBearing(from: coords[0], to: coords[1])
            setCameraRotation(angle)
        }
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
        let span = MKCoordinateSpan(latitudeDelta: spanLat * 1.2, longitudeDelta: spanLon * 1.2)
        
        let region = MKCoordinateRegion(center: center, span: span)
        self.cameraPosition = .region(region)
    }
    
    private func calculateBearing(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Double {
        let deltaLongitude = end.longitude - start.longitude
        let deltaLatitude = end.latitude - start.latitude
        let angle = atan2(deltaLongitude, deltaLatitude)
        return angle * 180 / .pi
    }
    
    private func setCameraRotation(_ angle: Double) {
        if let region = cameraPosition.region {
            let adjustedAngle = 90 - angle  // Rotate to make the line horizontal
            let camera = MapCamera(centerCoordinate: region.center, distance: 1000, heading: 0, pitch: adjustedAngle)
            self.cameraPosition = .camera(camera)
        }
    }
    
}

#Preview {
    MapView()
}
