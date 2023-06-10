//
//  MapViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 11.04.2023.
//

import Combine
import CoreLocation
import Foundation
import MapKit

final class MapViewModel: ObservableObject {
    @Published var isCircleOnMap: Bool = false
    @Published var circleRadius: Double = 1000.0
    @Published var circleCenter: CLLocationCoordinate2D? // Added circleCenter property
    var circle: MKCircle? // Added circle property
    var locationManager = LocationManager()
}


