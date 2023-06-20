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
    @StateObject var alertService = AlertService.shared
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, interactionModes: viewModel.circleMod == CircleMode.deleteCircle ? [] : .all,
                showsUserLocation: true,
                userTrackingMode: .none)
                .overlay(
                    Circle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: viewModel.circleRadius * 2, height: viewModel.circleRadius * 2)
                        .opacity(viewModel.circleExists ? 1 : 0)
                )
            
            VStack {
                Spacer()
                if viewModel.circleMod == .setCircle {
                    HStack {
                        Text("Circle Boyutu: \(Int(viewModel.circleRadius))")
                        Slider(value: $viewModel.circleRadius, in: 50 ... 1000)
                            .accentColor(Color("Orange"))
                    }
                    .padding()
                    .background(Color("Gray"))
                    .cornerRadius(20)
                    .padding()
                    .padding(.bottom, 100)
                }
            }

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        switch viewModel.circleMod {
                        case .addCircle:
                            viewModel.drawCircleAtCenter()
                        case .setCircle:
                            viewModel.circleMod = .deleteCircle
                        case .deleteCircle:
                            viewModel.deleteCircle()
                        }

                    }) {
                        Text(viewModel.buttonTitle)
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                            .background(Color("Orange"))
                            .cornerRadius(20)
                    }
                    .padding()
                    .background(Color("Orange"))
                    .cornerRadius(20)
                }
                Spacer()
            }
            .padding()
        }.alert(isPresented: $alertService.isPresenting) {
            alertService.alert
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapViewModel())
    }
}
