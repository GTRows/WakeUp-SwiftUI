//
//  CustomCenterStyleView.swift
//  testtestasd
//
//  Created by Fatih Acıroğlu on 1.06.2023.
//

import SwiftUI
import AxisTabView

struct CustomCenterStyleView: ATBackgroundStyle {
    
    var state: ATTabState
    var radius: CGFloat = 80
    var depth: CGFloat = 0.8
    
    init(_ state: ATTabState, radius: CGFloat, depth: CGFloat) {
        self.state = state
        self.radius = radius
        self.depth = depth
    }
    
    var body: some View {
        let tabConstant = state.constant.tab
        GeometryReader { proxy in
            ATCurveShape(radius: radius, depth: depth, position: 0.5)
                .fill(Color("DarkGray"))
                .frame(height: tabConstant.normalSize.height + (state.constant.axisMode == .bottom ? state.safeAreaInsets.bottom : state.safeAreaInsets.top))
                .scaleEffect(CGSize(width: 1, height: state.constant.axisMode == .bottom ? 1 : -1))
                .mask(
                    Rectangle()
                        .frame(height: proxy.size.height + 100)
                )
                .shadow(color: tabConstant.shadow.color,
                        radius: tabConstant.shadow.radius,
                        x: tabConstant.shadow.x,
                        y: tabConstant.shadow.y)
        }
        .animation(.easeInOut, value: state.currentIndex)
    }
}


//struct CustomCenterStyleView_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCenterStyleView()
//    }
//}
