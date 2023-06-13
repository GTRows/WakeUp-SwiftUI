//
//  WorkShopView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import SwiftUI

struct WorkShopView: View {
    @StateObject var alertService = AlertService.shared
    @ObservedObject var viewModel = WorkShopViewModel()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.getUserPackages()
                    viewModel.selectedTab = .myPackages
                }, label: {
                    Text("My Packages")
                        .font(.title2)
                        .foregroundColor(viewModel.selectedTab == .myPackages ? .white : .gray)
                })
                Spacer()
                Button(action: {
                    viewModel.getAllPackages()
                    viewModel.selectedTab = .community

                }, label: {
                    Text("Community")
                        .font(.title2)
                        .foregroundColor(viewModel.selectedTab == .community ? .white : .gray)
                })
                Spacer()
            }
            if viewModel.packages.isEmpty {
                Spacer()
                Text("TEMP LOADING")
                    .shimmering()
                    .onAppear(){
                        viewModel.getUserPackages()
                    }
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.packages) { package in
                            PackageCellView(viewModel: PackageViewModel(package: package))
                        }
                    }
                }
            }
            Spacer()
                .alert(isPresented: $alertService.isPresenting) {
                    alertService.alert
                }
        }
    }
}

struct WorkShopView_Previews: PreviewProvider {
    static var previews: some View {
        WorkShopView()
    }
}
