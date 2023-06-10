//
//  TabButtonView.swift
//  testtestasd
//
//  Created by Fatih Acıroğlu on 1.06.2023.
//

import AxisTabView
import SwiftUI

struct TabButtonView: View {
    @Binding var constant: ATConstant
    @Binding var selection: Int

    let tag: Int
    let isSelection: Bool
    let systemName: String

    @State private var y: CGFloat = 0
    
    var content: some View {
        VStack{
            ZStack(alignment: .leading) {
                Image(systemName: systemName)
                    .resizable()
                    .scaledToFit()
                    .font(.system(size: 24))
                    .padding(7)
                    .padding(.top, systemName != "sleep" ? 7 : 0)
                    .frame(width: systemName == "sleep" ? 65  : 50, height: systemName == "sleep" ? 65 : 50)
                    .background(systemName == "sleep" ? Color("DarkGray") : Color.clear)
                    .clipShape(Circle())
            }
            .foregroundColor(isSelection ? (systemName == "sleep" ? Color.pink : Color(.white)) : (systemName == "sleep" ? Color("Gray") : Color("Gray")))
            .clipShape(Capsule())
            .offset(y: positionY)
            if isSelection && systemName != "sleep" {
                // tiny flat stick
                withAnimation(.linear) {
                    Capsule()
                        .fill(Color(.white))
                        .frame(width: 20, height: 2)
                        .offset(y: -10)
                }
                
            }
        }
    }

    var body: some View {
        if constant.axisMode == .top {
            content
        } else {
            content
        }
    }

    private var positionY: CGFloat {
        if systemName == "sleep" {
            return constant.axisMode == .bottom ? -20 : 20
        }
        return 0
    }
}
