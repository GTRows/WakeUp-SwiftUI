//
//  InitialView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 4.06.2023.
//

import FirebaseAuth
import SwiftUI

struct InitialView: View {
    @AppStorage("uid") var userID: String = ""
    let persistenceController = PersistenceController.shared
    
    var body: some View {
        if userID == "" {
            AuthView()
        } else {
            TabBarView()
                .preferredColorScheme(.dark)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .task {
                    print(Auth.auth().currentUser)
                }
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
