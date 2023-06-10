//
//  WorkShopView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import SwiftUI

struct WorkShopView: View {
    @ObservedObject var viewModel = WorkShopViewModel()
    init(){}
    var body: some View {
        VStack{
            ScrollView{
                Text("WorkShopView")
            }
        }
    }
    
    
}

struct WorkShopView_Previews: PreviewProvider {
    static var previews: some View {
        WorkShopView()
    }
}
