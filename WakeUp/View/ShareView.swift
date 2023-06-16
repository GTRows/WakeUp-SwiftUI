//
//  ShareView.swift
//  WakeUp
//
//  Created by Fatih Acıroğlu on 16.06.2023.
//

import SwiftUI

struct ShareView: View {
    @State var isSharing: Bool = false
    @State var emailToShare: String = ""
    var data: ShareAbleCellProtocol
    
    init(data: ShareAbleCellProtocol) {
        self.data = data
    }
    
    
    var body: some View {
        VStack {
            Text("Share This \(data.getNameModel()):")
                .font(.title)
            
            TextField("Enter email", text: $emailToShare)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Share") {
                
            }
            .padding()
            Button("Cancel") {
                isSharing = false
            }
            .padding()
        }
    }
}

struct ShareView_Previews: PreviewProvider {
    static var previews: some View {
        ShareView(data: AlarmModel())
    }
}
