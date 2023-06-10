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
    @State private var user : UserModel = Constants.currentUser
    
    
    init() {
        self.user = FireBaseService.shared.getUser()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(user.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 200)
                    .clipShape(Circle())
                    .padding(.top, 50)
                VStack {
                    Text(user.name)
                        .fontWeight(.bold)
                    Text(user.email)
                        .font(.caption)
                }
                .padding(.bottom,20)
                // ProfileSettingsView navigate
                NavigationLink(
                    destination: ProfileSettingsView(user: user),
                    label: {
                        ZStack{
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
                ZStack{
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
                ZStack{
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
                    ZStack{
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
