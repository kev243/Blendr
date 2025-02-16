//
//  PopupView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-10.
//

import SwiftUI

struct PopupView: View {
    let icon : String
    let headline:String
    let subheadline: String
    let color:Color
    var body: some View {
        VStack(){
           
            HStack{
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 20 , height: 20)
                    .padding(.horizontal, 5)
                VStack(alignment:.leading){
                    Text(headline)
                        .font(.headline)
                    Text(subheadline)
                        .font(.subheadline)
                }
            }
           
        }
        .padding()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ , alignment: .leading)
        .foregroundStyle(.white)
        .background(color)
        .cornerRadius(50)
        .padding(.horizontal,10)
        
    }
}

#Preview {
    PopupView(icon: "exclamationmark.triangle.fill", headline: "Headline here", subheadline: "Subheadine here", color: Color("Error"))
}
