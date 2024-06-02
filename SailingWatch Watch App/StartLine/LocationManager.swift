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
    
    /// Calculate user distance from line
    func calculateDistanceFromLine() -> CLLocationDistance {
        guard let pointA = pointALocation, let pointB = pointBLocation,  let userLocation = liveLocation else {
            return 0.0
        }
        
        let lineStart = pointA.coordinate
        let lineEnd = pointB.coordinate
        
        let userPoint = MKMapPoint(userLocation.coordinate)
        let start = MKMapPoint(lineStart)
        let end = MKMapPoint(lineEnd)
        
        let a = userPoint.x - start.x
        let b = userPoint.y - start.y
        let c = end.x - start.x
        let d = end.y - start.y
        
        let dot = a * c + b * d
        let lenSq = c * c + d * d
        let param = (lenSq != 0) ? (dot / lenSq) : -1
        
        let xx: Double
        let yy: Double
        
        if param < 0 {
            xx = start.x
            yy = start.y
        } else if param > 1 {
            xx = end.x
            yy = end.y
        } else {
            xx = start.x + param * c
            yy = start.y + param * d
        }
        
        let dx = userPoint.x - xx
        let dy = userPoint.y - yy
        
        return sqrt(dx * dx + dy * dy)
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