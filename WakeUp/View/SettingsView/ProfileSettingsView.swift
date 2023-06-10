//
//  ProfileSettingsView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 5.06.2023.
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject private var viewModel = ProfileSettingsViewModel()
    @State public var user: UserModel
    @State private var showingImagePicker: Bool = false
    var body: some View {
        VStack {
            Button {
                showingImagePicker = true
            } label: {
                Image(user.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 200)
                    .clipShape(Circle())
                    .padding(.top, 50)
            }
            TextField("Name", text: $user.name)
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
                FireBaseService.shared.updateUser(user: user) { result in
                    switch result {
                    case let .success(user):
                        print("User successfully updated")
                        self.user = user
                    case let .failure(error):
                        print("Error updating user: \(error)")
                        AlertService.shared.show(error: error)
                    }
                }
            }) {
                // sign out view
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.red)
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

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView(user: Constants.errrorUser)
    }
}
