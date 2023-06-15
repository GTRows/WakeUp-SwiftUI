//
//  ProfileSettingsView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 5.06.2023.
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject private var viewModel: ProfileSettingsViewModel
    @State private var showingImagePicker: Bool = false

    init(viewModel: ProfileSettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            Button {
                showingImagePicker = true
            } label: {
                ZStack {
                    Image(uiImage: viewModel.image ?? UIImage(systemName: "person.crop.circle.fill")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color("Gray"))
                        .frame(width: 250, height: 200)
                        .padding(.top, 50)
                        .frame(maxHeight: 200)
                }.frame(width: UIScreen.main.bounds.width - 40, height: 200)
                    .padding()
            }
            TextField("Name", text: $viewModel.user.name)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Orange"), lineWidth: 1)
                )
                .padding(.horizontal, 16)
                .padding(.bottom)
            Spacer()
            Button(action: {
                viewModel.editUser()
            }) {
                // sign out view
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Spacer()
                        Text("Update Profile")
                        Spacer()
                    }
                    .frame(maxWidth: 250)
                    .foregroundColor(.black)
                    .padding()
                }.frame(width: 250, height: 50)
            }
            .padding(.bottom, 100)
        }.sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.image)
        }
    }
}

// struct ProfileSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSettingsView(viewModel: Constants.errrorUser)
//    }
// }
