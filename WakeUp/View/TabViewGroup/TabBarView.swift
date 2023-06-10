////
////  ContentView.swift
////  testtestasd
////
////  Created by Fatih Acıroğlu on 1.06.2023.
////
//
import SwiftUI
import AxisTabView

struct TabBarView: View {
    @State private var selection: Int = 0
    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false), tab: .init())
    @State private var radius: CGFloat = 70
    @State private var concaveDepth: CGFloat = 0.85

    var body: some View {
        GeometryReader { proxy in
            AxisTabView(selection: $selection, constant: constant) { state in
                CustomCenterStyleView(state, radius: radius, depth: concaveDepth)
            } content: {
                ControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth, tag: 0, systemName: "alarm", safeArea: proxy.safeAreaInsets)
                ControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth,  tag: 1, systemName: "map", safeArea: proxy.safeAreaInsets)
                ControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth,  tag: 2, systemName: "sleep", safeArea: proxy.safeAreaInsets)
                ControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth,  tag: 3, systemName: "person", safeArea: proxy.safeAreaInsets)
                ControlView(selection: $selection, constant: $constant, radius: $radius, concaveDepth: $concaveDepth,  tag: 4, systemName: "gearshape", safeArea: proxy.safeAreaInsets)
            }
        }
        .animation(.easeInOut, value: constant)
        .animation(.easeInOut, value: radius)
        .animation(.easeInOut, value: concaveDepth)
        .navigationTitle("Screen \(selection + 1)")
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
