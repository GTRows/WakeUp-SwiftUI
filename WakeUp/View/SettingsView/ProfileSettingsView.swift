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
                if let uiImage = viewModel.image {
                    Image(uiImage: uiImage) // Display the selected image.
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 200)
                        .clipShape(Circle())
                        .padding(.top, 50)
                } else if let url = URL(string: viewModel.user.avatar) {
                    URLImage(url: viewModel.user.avatar)
                        .frame(width: 250, height: 200)
                        .clipShape(Circle())
                        .padding(.top, 50)
                } else {
                    Image("placeholder") // Placeholder image if the user avatar URL is not valid.
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 200)
                        .clipShape(Circle())
                        .padding(.top, 50)
                }
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


//struct ProfileSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSettingsView(viewModel: Constants.errrorUser)
//    }
//}
