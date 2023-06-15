//
//  ProfileView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu
//

import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @StateObject var alertService = AlertService.shared
    @AppStorage("uid") var userID: String = ""
    @State private var user: UserModel = FireBaseService.shared.getUser()
    @ObservedObject var viewModel = ProfileViewModel()

    init() {
        user = FireBaseService.shared.getUser()
    }

    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: viewModel.avatarImage ?? UIImage(systemName: "person.crop.circle")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color("Gray"))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                    .padding()
                    .onAppear(){
                        viewModel.loadAvatar()
                    }

                VStack {
                    Text(user.name)
                        .fontWeight(.bold)
                    Text(user.email)
                        .font(.caption)
                }
                .padding(.bottom, 20)
                // ProfileSettingsView navigate
                NavigationLink(
                    destination: ProfileSettingsView(viewModel: ProfileSettingsViewModel(user: user)),
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.gray)
                            HStack {
                                Image(systemName: "gear")
                                Spacer()
                                Text("Profile Settings")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .frame(maxWidth: 250)
                            .foregroundColor(.black)
                            .padding()
                        }.frame(width: 250, height: 50)
                            .foregroundColor(.gray)
                    }
                )
                // empty view
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.gray)
                    HStack {
                        Image(systemName: "gear")
                        Spacer()
                        Text("Empty")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: 250)
                    .foregroundColor(.black)
                    .padding()
                }.frame(width: 250, height: 50)
                    .foregroundColor(.gray)
                    .padding()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.gray)
                    HStack {
                        Image(systemName: "gear")
                        Spacer()
                        Text("Profile Settings")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .frame(maxWidth: 250)
                    .foregroundColor(.black)
                    .padding()
                }.frame(width: 250, height: 50)
                    .foregroundColor(.gray)

                Spacer()
                Button(action: {
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        withAnimation {
                            userID = ""
                        }
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                        AlertService.shared.show(error: signOutError)
                    }
                }) {
                    // sign out view
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.red)
                        HStack {
                            Image(systemName: "arrowshape.turn.up.left")
                            Spacer()
                            Text("Sign Out")
                            Spacer()
                        }
                        .frame(maxWidth: 250)
                        .foregroundColor(.black)
                        .padding()
                    }.frame(width: 250, height: 50)
                }
                .padding(.bottom, 100)

            }.alert(isPresented: $alertService.isPresenting) {
                alertService.alert
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
