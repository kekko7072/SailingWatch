//
//  Point.swift
//  SailingWatch Watch App
//
//  Created by Francesco Vezzani on 02/06/24.
//

import Foundation
import CoreLocation
import SwiftUI

struct PointAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let tint: Color
    let title: String?
}
