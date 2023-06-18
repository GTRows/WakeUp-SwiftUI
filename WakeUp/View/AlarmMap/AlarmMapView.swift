//
//  AlarmMapView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 5.06.2023.
//

import SwiftUI

struct AlarmMapView: View {
//    @ObservedObject var viewModel = MapViewModel()

    var body: some View {
        VStack {
            Text("Hello, World!")
//            ZStack {
////                MapView(isCircleOnMap: $viewModel.isCircleOnMap, circleRadius: $viewModel.circleRadius, centerCoordinate: $viewModel.circleCenter )
////                    .edgesIgnoringSafeArea(.all)
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button(action: {
////                            viewModel.isCircleOnMap.toggle()
//                        }) {
//                            Text(viewModel.isCircleOnMap ? "Delete Circle" : "Add Circle")
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.red)
//                                .cornerRadius(10)
//                        }
//                        .padding()
//                    }
//                    Spacer()
//                }
//            }
//
//            Text("Circle Radius: \(Int(viewModel.circleRadius))")
//            Slider(value: $viewModel.circleRadius, in: 100 ... 5000, step: 100)
//                .padding()
//                .padding(.bottom, 100)
        }
    }
}



struct AlarmMapView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmMapView()
    }
}
