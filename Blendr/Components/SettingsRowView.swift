//
//  SettingsRowView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-18.
//

import SwiftUI


struct SettingsRowView: View {
    let imageName:String
    let title:String
    let tintColor: Color
    
    var body: some View {
        HStack{
            Image(systemName: imageName)
                .imageScale(.small)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
        }
    }
}

#Preview {
    SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}
