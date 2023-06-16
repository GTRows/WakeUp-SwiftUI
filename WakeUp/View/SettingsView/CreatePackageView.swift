//
//  CreatePackageView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 10.06.2023.
//

import Shimmer
import SwiftUI
import UIKit

struct CreatePackageView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CreatePackageViewModel()
    @State private var showingImagePicker: Bool = false

    private let maxLengthDesc = 50
    private let maxLengthName = 15

    var body: some View {
        VStack {
            Text("Create Package")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 16)

            Image(uiImage: viewModel.image ?? UIImage(imageLiteralResourceName: "defaultPackage"))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 60, height: 200)
                .cornerRadius(20)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("Orange"), lineWidth: 2)
                })

                .onTapGesture {
                    showingImagePicker.toggle()
                }

            HStack {
                Text("Package Name")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading, 16)

                TextField("Package Name", text: $viewModel.name, onCommit: {
                    if viewModel.name.count > maxLengthName {
                        viewModel.name = String(viewModel.name.prefix(maxLengthName))
                        AlertService.shared.showString(title: "Error", message: "Max length is \(maxLengthName)")
                    }
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color("Gray"))
                .cornerRadius(10)
            }
            .background(Color("DarkGray"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Orange"), lineWidth: 1)
            )
            .padding()

            HStack {
                Text("Package Description")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading, 16)

                TextField("Package Description", text: $viewModel.description, onCommit: {
                    if viewModel.description.count > maxLengthName {
                        viewModel.description = String(viewModel.description.prefix(maxLengthDesc))
                        AlertService.shared.showString(title: "Error", message: "Max length is \(maxLengthDesc)")
                    }
                })
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color("Gray"))
                .cornerRadius(10)
                
//                TextEditor(text: $viewModel.description)
//                    .scrollContentBackground(.hidden)
//                    .navigationTitle("Tsdfasdf")
//                    .onChange(of: viewModel.description) { _ in
//                        if viewModel.description.count > maxLengthDesc {
//                            viewModel.description = String(viewModel.description.prefix(maxLengthDesc))
//                            AlertService.shared.showString(title: "Error", message: "Max length is \(maxLengthDesc)")
//                        }
//                    }.padding(.horizontal, 10)
//                    .padding(.vertical, 10)
//                    .background(Color("Gray"))
//                    .cornerRadius(10)
                
            }
            .background(Color("DarkGray"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Orange"), lineWidth: 1)
            )
            .padding()

            HStack {
                Text("Vizibility")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading, 16)
                Spacer()
                Toggle(isOn: $viewModel.vizibility) {}
                    .toggleStyle(SwitchToggleStyle(tint: Color("Orange")))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .cornerRadius(10)
            }.background(Color("DarkGray"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Orange"), lineWidth: 1)
                )
                .padding()

            Button {
                if viewModel.image != nil {
                    viewModel.createPackage { Result in
                        switch Result {
                        case .success:
                            presentationMode.wrappedValue.dismiss()
                        case let .failure(error):
                            AlertService.shared.show(error: error)
                        }
                    }
                } else {
                    AlertService.shared.showString(title: "Error", message: "You need a select one")
                }
            } label: {
                Text("Create Package")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Color("Orange")
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom)
            }
            Spacer()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.image)
        }
    }
}

struct CreatePackageView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePackageView()
    }
}
