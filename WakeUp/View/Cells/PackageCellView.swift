//
//  PackageCellView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 13.06.2023.
//

import Shimmer
import SwiftUI
import UIKit

enum PackageCellViewMod {
    case workspace
    case show

    var boolValue: Bool {
        switch self {
        case .workspace:
            return false
        case .show:
            return true
        }
    }
}



struct PackageCellView: View {
    @StateObject var alertService = AlertService.shared
    @ObservedObject var viewModel: PackageViewModel
    @State var isExpendad: Bool = false
    @State var cellHeightDefault: Int = 400
    @State var cellHeight: Int = 400
    @State var mod: PackageCellViewMod
    
    

    init(package: PackageModel, mod: PackageCellViewMod = .workspace) {
        self.viewModel = PackageViewModel(package: package)
        self.mod = mod
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("DarkGray"))
                .frame(width: UIScreen.main.bounds.width - 40, height: CGFloat(cellHeight))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .onChange(of: cellHeight, perform: { newValue in
                    print("cellHeight: \(newValue)")
                    print("viewModel.package.alarms.count: \(viewModel.package.alarms.count)")
                })
                .onChange(of: isExpendad) { newValue in
                    withAnimation {
                        if newValue {
                            if viewModel.package.alarms.count > 1 {
                                cellHeight = 650
                            } else {
                                cellHeight = 450 + 135
                            }
                        } else {
                            cellHeight = cellHeightDefault
                        }
                    }
                }
            VStack(alignment: .leading) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                        .cornerRadius(20)
                        .padding(.leading, 20)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                        .cornerRadius(20)
                        .padding(.leading, 20)
                        .shimmering()
                }
                
                Text(viewModel.package.name)
                    .font(.largeTitle)
                    .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 5)

                if !viewModel.package.description.isEmpty{
                    withAnimation(.easeIn(duration: 1)){
                        Text(viewModel.package.description)
                            .font(.subheadline)
                            .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 5)
                            .multilineTextAlignment(.leading)
                    }
                } else {
                    Text("")
                        .onAppear(){
                            cellHeight = 350
                            cellHeightDefault = 350
                        }
                }

                Text(viewModel.package.Creator.email)
                    .font(.subheadline)
                    .frame(width: UIScreen.main.bounds.width - 40, alignment: .trailing)
                    .padding(.bottom)

                if isExpendad {
                    if viewModel.package.alarms.count > 1 {
                        ScrollView {
                            ForEach(viewModel.package.alarms, id: \.id) { alarm in
                                AlarmCellView(alarm: alarm, mod: AlarmCellViewMod.edit)
                                    .frame(width: UIScreen.main.bounds.width - 60)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .frame(height: 200)
                    } else {
                        AlarmCellView(alarm: viewModel.package.alarms[0], mod: AlarmCellViewMod.edit)
                            .frame(width: UIScreen.main.bounds.width - 60)
                            .padding(.horizontal, 20)
                    }
                    Button {
                        viewModel.usePackage()
                        AlertService.shared.showString(title: "Package used", message: "Package is used successfully.")
                        isExpendad.toggle()
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 5)
                            .background(
                                Color("Orange")
                            )
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Orange"), lineWidth: 1)
                            )
                            .frame(width: UIScreen.main.bounds.width - 40)
                    }.disabled(self.mod.boolValue)
                    .padding(.vertical, 10)
                }

                Button {
                    withAnimation {
                        isExpendad.toggle()
                    }
                } label: {
                    Image(systemName: isExpendad ? "chevron.up" : "chevron.down")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("Gray"))
                        .frame(width: UIScreen.main.bounds.width - 40)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: CGFloat(cellHeightDefault))
        }.foregroundColor(.white)
            .onTapGesture {
                if !isExpendad {
                    withAnimation {
                        isExpendad.toggle()
                    }
                }
            }
            .alert(isPresented: $alertService.isPresenting) {
                alertService.alert
            }
    }
}

struct PackageCellView_Previews: PreviewProvider {
    static var previews: some View {
        PackageCellView(package: Constants.tempPackages[0])
    }
}
