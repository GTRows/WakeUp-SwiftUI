//
//  ControlView.swift
//  testtestasd
//
//  Created by Fatih Acıroğlu on 1.06.2023.
//

import AxisTabView
import SwiftUI

struct ControlView: View {
    @Binding var selection: Int
    @Binding var constant: ATConstant
    @Binding var radius: CGFloat
    @Binding var concaveDepth: CGFloat
    
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets

    var body: some View {
        VStack {
            switch tag {
            case 0:
                HomeView()
            case 1:
                AlarmMapView()
            case 2:
                SleepView()
            case 3:
                AlarmListView()
            case 4:
                ProfileView()
            default:
                EmptyView()
            }
        }
        .tabItem(tag: tag, normal: {
            TabButtonView(constant: $constant, selection: $selection, tag: tag, isSelection: false, systemName: systemName)
        }, select: {
            TabButtonView(constant: $constant, selection: $selection, tag: tag, isSelection: true, systemName: systemName)
        })
        
    }

    private func getTopPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .top ? constant.tab.normalSize.height + safeArea.top : 0
    }

    private func getBottomPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .bottom ? constant.tab.normalSize.height + safeArea.bottom : 0
    }
}
