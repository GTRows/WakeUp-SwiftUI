//
//  AuthViewModel.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 9.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isUserLoggedIn: Bool = false
    private let auth = Auth.auth()

    init() {
        auth.addStateDidChangeListener(handleAuthStateChange)
    }

    func handleAuthStateChange(_ auth: Auth, _ user: User?) {
        self.user = user
        isUserLoggedIn = user != nil
    }

    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
            } else {
                self.user = result?.user
            }
            self.isUserLoggedIn = self.user != nil
        }
    }

    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else {
                self.user = result?.user
            }
            self.isUserLoggedIn = self.user != nil
        }
    }
}
