//
//  CustomAlertView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-08.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var showAlert: Bool
    var title: String
    var message: String
    
    var body: some View {
        EmptyView()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(title),
                    message: Text(message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

//#Preview {
//    CustomAlertView(showAlert: false, title: "Oups", message: "Exemple Alert")
//}
