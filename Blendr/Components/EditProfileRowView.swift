//
//  EditProfileRowView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-15.
//

import SwiftUI

struct EditProfileRowView: View {
    let title : String
    let placeholder: String
    @Binding var text: String
    var body: some View {
        HStack{
            Text(title)
                .padding(.leading,8)
                .frame(width: 120,alignment: .leading)
            
            VStack{
                TextField(placeholder, text: $text)
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 45)
    }
}


//#Preview {
//    EditProfileRowView(title: "Nom", placeholder: "Instagram", text: $text)
//}
