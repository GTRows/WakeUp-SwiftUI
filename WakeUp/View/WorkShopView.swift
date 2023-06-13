//
//  WorkShopView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import SwiftUI

struct WorkShopView: View {
    @ObservedObject var viewModel = WorkShopViewModel()

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(Constants.tempPackages) { package in
                        PackageCellView(viewModel: PackageViewModel(package: package))
                    }
                }
            }
        }
    }
}

struct WorkShopView_Previews: PreviewProvider {
    static var previews: some View {
        WorkShopView()
    }
}
