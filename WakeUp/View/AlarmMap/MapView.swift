//
//  MapView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import MapKit
import SwiftUI

import MapKit
import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        VStack {
            Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .none)
                .onLongPressGesture {
                    viewModel.drawCircleAtCenter()
                }
                .overlay(
                    Circle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: viewModel.circleRadius * 2, height: viewModel.circleRadius * 2)
                        .opacity(viewModel.circleExists ? 1 : 0)
                )
            Slider(value: $viewModel.circleRadius, in: 50 ... 500)
            Button(action: {
                viewModel.deleteCircle()
            }) {
                Text("Delete Circle")
            }.padding()
                .padding(.bottom, 100)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}
