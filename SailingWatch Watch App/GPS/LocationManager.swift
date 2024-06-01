//
//  LocationManager.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 10/09/23.
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
        print("INITIALIZED")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationStatus = locationManager.authorizationStatus
        pointALocation = locationManager.location
        
        switch locationManager.authorizationStatus {
        case .notDetermined: print( "notDetermined")
        case .authorizedWhenInUse:  print(  "authorizedWhenInUse")
        case .authorizedAlways:  print(  "authorizedAlways")
        case .restricted:  print(  "restricted")
        case .denied:  print(  "denied")
        default:  print(  "unknown")
        }
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
    func lineToSet() {
        pointALocation = nil
        pointBLocation = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        liveLocation = location
        print(#function, location)
    }
    
    func getCurrentLocation() -> CLLocation? {
        if(locationStatus ==  .notDetermined || locationStatus == .restricted || locationStatus == .denied){
            locationManager.requestWhenInUseAuthorization()
            locationStatus = locationManager.authorizationStatus
        }
        
        return locationManager.location
    }
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationStatus = locationManager.authorizationStatus
        liveLocation = locationManager.location
       
        
        switch locationManager.authorizationStatus {
        case .notDetermined: print( "notDetermined")
        case .authorizedWhenInUse:  print(  "authorizedWhenInUse")
        case .authorizedAlways:  print(  "authorizedAlways")
        case .restricted:  print(  "restricted")
        case .denied:  print(  "denied")
        default:  print(  "unknown")
        }
    }
}
