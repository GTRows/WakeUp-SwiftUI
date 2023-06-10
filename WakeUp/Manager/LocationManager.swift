//
//  LocationManager.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 5.06.2023.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var circle: MKCircle?  // Kullanıcının belirlediği çemberi temsil eder.
    
    @Published var location: CLLocation?
    @Published var didSetInitialRegion: Bool = false
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        if let circle = self.circle {
            let mapPoint = MKMapPoint(location.coordinate)
            if circle.boundingMapRect.contains(mapPoint) {
                // AlarmService.shared.fireAlarm() kodunu buraya yazabilirsiniz.
                // Eğer bu mevcut değilse, kendi ihtiyaçlarınıza göre bir uyarı tetikleme mekanizması sağlamalısınız.
                AlarmService.shared.fireAlarm(alarm: AlarmModel())
            }
        }
    }

}

