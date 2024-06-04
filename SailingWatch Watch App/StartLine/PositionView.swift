//
//  PositionView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 02/06/24.
//

import SwiftUI
import CoreLocation

struct PositionView: View {
    @StateObject var userLocation = LocationManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw line connecting points
                if userLocation.pointALocation != nil && userLocation.pointBLocation != nil {
                    LineView(points: [userLocation.pointALocation!.coordinate, userLocation.pointBLocation!.coordinate], size: geometry.size)
                        .stroke(Color.green, lineWidth: 8)
                }
                
                // Draw circles for points
                if let pointA = userLocation.pointALocation {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 10, height: 10)
                        .position(convertCoordinateToCGPoint(coordinate: pointA.coordinate, in: geometry.size))
                }
                if let pointB = userLocation.pointBLocation {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .position(convertCoordinateToCGPoint(coordinate: pointB.coordinate, in: geometry.size))
                }
                if let userPoint = userLocation.liveLocation {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                        .position(convertCoordinateToCGPoint(coordinate: userPoint.coordinate, in: geometry.size))
                }
            }
        }
    }
    
    private func convertCoordinateToCGPoint(coordinate: CLLocationCoordinate2D, in size: CGSize) -> CGPoint {
        // Assuming the coordinates are normalized between the two points
        guard let minLat = userLocation.pointALocation?.coordinate.latitude,
              let maxLat = userLocation.pointBLocation?.coordinate.latitude,
              let minLon = userLocation.pointALocation?.coordinate.longitude,
              let maxLon = userLocation.pointBLocation?.coordinate.longitude else {
            return .zero
        }
        
        let latitudeSpan = maxLat - minLat
        let longitudeSpan = maxLon - minLon
        
        let x = (coordinate.latitude - minLat) / latitudeSpan * size.width
        let y = (coordinate.longitude - minLon) / longitudeSpan * size.height
        
        return CGPoint(x: x, y: y)
    }
}

struct LineView: Shape {
    var points: [CLLocationCoordinate2D]
    var size: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        
        let startPoint = CGPoint(
            x: CGFloat((points[0].latitude - points.map { $0.latitude }.min()!) / (points.map { $0.latitude }.max()! - points.map { $0.latitude }.min()!)) * size.width,
            y: CGFloat((points[0].longitude - points.map { $0.longitude }.min()!) / (points.map { $0.longitude }.max()! - points.map { $0.longitude }.min()!)) * size.height
        )
        path.move(to: startPoint)
        
        for point in points {
            let cgPoint = CGPoint(
                x: CGFloat((point.latitude - points.map { $0.latitude }.min()!) / (points.map { $0.latitude }.max()! - points.map { $0.latitude }.min()!)) * size.width,
                y: CGFloat((point.longitude - points.map { $0.longitude }.min()!) / (points.map { $0.longitude }.max()! - points.map { $0.longitude }.min()!)) * size.height
            )
            path.addLine(to: cgPoint)
        }
        
        return path
    }
}

#Preview {
    PositionView()
}
