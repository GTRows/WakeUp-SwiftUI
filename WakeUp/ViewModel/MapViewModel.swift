//
//  MapViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 11.04.2023.
//

import CoreLocation
import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var circleRadius: CGFloat = 100.0
    private let locationManager = CLLocationManager()
    @Published var region: MKCoordinateRegion
    @Published var circleExists: Bool = false
    @Published var initialLoad = true

    override init() {
        // Define initial region
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func drawCircleAtCenter() {
        circleExists = true
    }

    func deleteCircle() {
        circleExists = false
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // If it's the initial load, update the region.
        if initialLoad {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                self.initialLoad = false
            }
        }

        // If the user is inside the circle
        if circleExists && location.distance(from: CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)) <= Double(circleRadius) {
            AlarmService.shared.fireAlarm(alarm: AlarmModel())
            deleteCircle()
        }
    }
}
