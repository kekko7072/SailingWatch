//
//  LocationManager.swift
//  SailingWatch Watch App
//
//  Edited by Francesco Vezzani on 01/06/24.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var pointALocation: CLLocation?
    @Published var pointBLocation: CLLocation?
    @Published var liveLocation: CLLocation?

    override init() {
        super.init()
        configureLocationManager()
        requestAuthorization()
    }

    /// Configure the location manager settings.
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    /// Request authorization to use location services.
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationStatus = locationManager.authorizationStatus
        pointALocation = locationManager.location
        printAuthorizationStatus()
    }

    /// Print the current authorization status.
    private func printAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("notDetermined")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        case .authorizedAlways:
            print("authorizedAlways")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            print("unknown")
        }
    }

    /// Reset the locations for point A and point B.
    func lineToSet() {
        pointALocation = nil
        pointBLocation = nil
    }

    /// Returns the current location if authorized, otherwise requests authorization.
    func getCurrentLocation() -> CLLocation? {
        guard let status = locationStatus else { return nil }
        
        if status == .notDetermined || status == .restricted || status == .denied {
            requestAuthorization()
        }

        return locationManager.location
    }
    
    /// Function to calculate the Haversine distance
    func haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let R = 6371000.0 // Earth radius in meters
        let dLat = (lat2 - lat1).degreesToRadians
        let dLon = (lon2 - lon1).degreesToRadians
        let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1.degreesToRadians) * cos(lat2.degreesToRadians) * sin(dLon / 2) * sin(dLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        return R * c
    }
    
    /// Calculate user distance from line
    func calculateDistanceFromLine() -> CLLocationDistance {
        
        guard let pointA = pointALocation, let pointB = pointBLocation,  let user = liveLocation else {
            return 0.0
        }
        
        let start = pointA.coordinate
        let end = pointB.coordinate
        let userLocation = user.coordinate

        // Convert lat/lon to Cartesian coordinates
        let userX = haversineDistance(lat1: start.latitude, lon1: start.longitude, lat2: userLocation.latitude, lon2: start.longitude)
        let userY = haversineDistance(lat1: start.latitude, lon1: start.longitude, lat2: start.latitude, lon2: userLocation.longitude)
        
        let x1 = 0.0
        let y1 = 0.0
        let x2 = haversineDistance(lat1: start.latitude, lon1: start.longitude, lat2: end.latitude, lon2: start.longitude)
        let y2 = haversineDistance(lat1: start.latitude, lon1: start.longitude, lat2: start.latitude, lon2: end.longitude)
        
        // Calculate the projection of the point onto the line
        let A = userX - x1
        let B = userY - y1
        let C = x2 - x1
        let D = y2 - y1
        
        let dot = A * C + B * D
        let lenSq = C * C + D * D
        let param = dot / lenSq
        
        if param < 0 || param > 1 {
            // Calculate the distance to the nearest endpoint
            let dist1 = sqrt((userX - x1) * (userX - x1) + (userY - y1) * (userY - y1))
            let dist2 = sqrt((userX - x2) * (userX - x2) + (userY - y2) * (userY - y2))
            return min(dist1, dist2)
        } else {
            // Calculate the perpendicular distance to the line segment
            let xx = x1 + param * C
            let yy = y1 + param * D
            return sqrt((userX - xx) * (userX - xx) + (userY - yy) * (userY - yy))
        }
    }

    // MARK: - CLLocationManagerDelegate Methods

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        liveLocation = location
        print(#function, location)
    }

    /// Returns a string representation of the current authorization status.
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }

        switch status {
        case .notDetermined:
            return "notDetermined"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .authorizedAlways:
            return "authorizedAlways"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        @unknown default:
            return "unknown"
        }
    }
}

// MARK: Extension to double
extension Double {
    var degreesToRadians: Double { self * .pi / 180.0 }
}
