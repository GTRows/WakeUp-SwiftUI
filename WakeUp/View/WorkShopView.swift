//
//  WorkShopView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.06.2023.
//

import SwiftUI
import SwipeActions
import UIKit

struct WorkShopView: View {
    @StateObject var alertService = AlertService.shared
    @ObservedObject var viewModel = WorkShopViewModel()
    @State private var wrappedVal = 0

    @State private var temp = 0

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
                Text("You don't have any packages yet.")
                    .shimmering()
                    .onAppear {
                        viewModel.getUserPackages()
                    }
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.packages) { package in
                            if viewModel.selectedTab == .myPackages {
                                SwipeView {
                                    PackageCellView(package: package)
                                } trailingActions: { context in
                                    SwipeAction(systemImage: "trash", action: {
                                        viewModel.deletePackage(package: package)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            context.state.wrappedValue = .closed
                                        }
                                    }).background(Color(red: 1, green: 0, blue: 0))
                                        .onChange(of: wrappedVal) { _ in
                                            context.state.wrappedValue = .closed
                                        }
                                }
                                .swipeActionsStyle(.cascade)
                                .padding(.horizontal)
                            } else {
                                PackageCellView(package: package)
                            }
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
