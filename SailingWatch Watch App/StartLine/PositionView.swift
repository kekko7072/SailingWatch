//
//  PositionView.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 02/06/24.
//

import SwiftUI

struct PositionView: View {
    @StateObject var userLocation = LocationManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw line connecting points
                if userLocation.pointALocation != nil && userLocation.pointBLocation != nil {
                    let points = [userLocation.pointALocation!.coordinate, userLocation.pointBLocation!.coordinate]
                    LineView(points: points)
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
        // Convert coordinate to CGPoint. This method will depend on how you want to map your coordinates to the view.
        // For simplicity, let's assume the coordinates are normalized between 0 and 1.
        let x = CGFloat((coordinate.latitude + 90) / 180) * size.width
        let y = CGFloat((coordinate.longitude + 180) / 360) * size.height
        return CGPoint(x: x, y: y)
    }
}

struct LineView: Shape {
    var points: [CLLocationCoordinate2D]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard points.count > 1 else { return path }
        
        let startPoint = CGPoint(
            x: CGFloat((points[0].latitude + 90) / 180) * rect.width,
            y: CGFloat((points[0].longitude + 180) / 360) * rect.height
        )
        path.move(to: startPoint)
        
        for point in points {
            let cgPoint = CGPoint(
                x: CGFloat((point.latitude + 90) / 180) * rect.width,
                y: CGFloat((point.longitude + 180) / 360) * rect.height
            )
            path.addLine(to: cgPoint)
        }
        
        return path
    }
}

#Preview {
    PositionView()
}

