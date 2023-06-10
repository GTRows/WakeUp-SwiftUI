//
//  MapView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var isCircleOnMap: Bool
    @Binding var circleRadius: Double
    @State private var centerCoordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true
        map.userTrackingMode = .follow
        map.delegate = context.coordinator

        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gesture:)))
        map.addGestureRecognizer(longPressGesture)

        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if isCircleOnMap {
            context.coordinator.addCircle(mapView: uiView, radius: circleRadius, center: uiView.centerCoordinate)
        } else {
            context.coordinator.circleCenter = nil  // Reset the circle center when the circle is removed
            context.coordinator.removeCircle(mapView: uiView)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var circle: MKCircle?
        var circleCenter: CLLocationCoordinate2D?

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
            print("HandleLongPress")

//            guard gesture.state == .began else { return }
//
//            let point = gesture.location(in: gesture.view)
//            if let coordinate = parent.getCoordinate(from: point) {
//                parent.isCircleOnMap = true
//                parent.circleRadius = 1000 // İstediğiniz değeri burada belirleyebilirsiniz
//
//                addCircle(mapView: gesture.view as! MKMapView, radius: parent.circleRadius, center: coordinate)
//            }
        }

        func addCircle(mapView: MKMapView, radius: Double, center: CLLocationCoordinate2D) {
            removeCircle(mapView: mapView)

            let circle = MKCircle(center: circleCenter ?? center, radius: radius) // Use the saved center
            mapView.addOverlay(circle)
            self.circle = circle
        }

        func removeCircle(mapView: MKMapView) {
            if let circle = circle {
                mapView.removeOverlay(circle)
                self.circle = nil
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circleOverlay = overlay as? MKCircle {
                let circleRenderer = MKCircleRenderer(circle: circleOverlay)
                circleRenderer.strokeColor = .red
                circleRenderer.fillColor = .red.withAlphaComponent(0.1)
                return circleRenderer
            } else {
                return MKOverlayRenderer(overlay: overlay)
            }
        }
    }

    func getCoordinate(from point: CGPoint) -> CLLocationCoordinate2D? {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              let mapView = window.subviews.compactMap({ $0 as? MKMapView }).first
        else {
            return nil
        }

        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        return coordinate
    }
}
