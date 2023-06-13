//
//  PackageCellView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 13.06.2023.
//

import Shimmer
import SwiftUI
import UIKit

struct PackageCellView: View {
    @ObservedObject var viewModel: PackageViewModel
    @State var isExpendad: Bool = false

    var body: some View {
        Button {
            if !isExpendad {
                isExpendad.toggle()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("DarkGray"))
                    .frame(width: UIScreen.main.bounds.width - 40, height: isExpendad ? 600 : 350)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)

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
                    }
                    Text(viewModel.package.name)
                        .font(.largeTitle)
                        .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                        .padding(.horizontal, 20)
                    Text(viewModel.package.description)
                        .font(.subheadline)
                        .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    if isExpendad {
                        ScrollView {
                            ForEach(viewModel.package.alarms, id: \.id) { alarm in
                                AlarmCellView(alarm: alarm, mod: AlarmCellViewMode.edit)
                                    .frame(width: UIScreen.main.bounds.width - 60)
                                    .padding(.horizontal, 20)
                            }
                        }
                        .frame(height: 200)
                        Button {
                            print("save")
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
                        }.padding(.vertical, 10)
                    }
                    
                    Button {
                        if isExpendad{
                            isExpendad.toggle()
                        }
                    } label: {
                        Image(systemName: isExpendad ? "chevron.up" : "chevron.down")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("Gray"))
                            .frame(width: UIScreen.main.bounds.width - 40)
                        
                    }

                    
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 350)
            }.foregroundColor(.white)
        }
    }
}

struct PackageCellView_Previews: PreviewProvider {
    static var previews: some View {
        PackageCellView(viewModel: PackageViewModel(package: Constants.tempPackages[0]))
    }
}
