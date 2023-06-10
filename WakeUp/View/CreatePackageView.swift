//
//  CreatePackageView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 10.06.2023.
//

import SwiftUI

struct CreatePackageView: View {
    @StateObject private var viewModel = CreatePackageViewModel()
    @State private var showingImagePicker: Bool = false

    var body: some View {
        VStack {
            Text("Create Package")
                .font(.title)
                .fontWeight(.bold)
                .padding(.leading, 16)
            Spacer()
            Text("Package Name")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 16)
            TextField("Package Name", text: $viewModel.name)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Orange"), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom)

            Toggle(isOn: $viewModel.vizibility) {
                Text("Vizibility")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading, 16)
            }
            .padding(.horizontal, 120)
            .padding(.bottom)

            Text("Select Package image")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 16)

            viewModel.image.map {
                Image(uiImage: $0)
                    .resizable()
                    .scaledToFit()
            }
            Button(action: {
                showingImagePicker = true
            }) {
                Text("Open Image Picker")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Color("Orange")
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("Orange"), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom)
            }
            Button {
                if viewModel.image != nil {
                    print("Create image")
//                    viewModel.createPackage()
                } else {
                    // show alert for not selected image
                    
                }

            } label: {
                Text("Create Package")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Color(.blue)
                    )
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.blue), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom)
            }.padding(.vertical, 25)
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
