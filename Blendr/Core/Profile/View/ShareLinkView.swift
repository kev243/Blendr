//
//  ShareLinkView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-23.
//

import SwiftUI

struct ShareLinkView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showCopiedNotification = false
    var username :String

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Clique sur le lien ci-dessous pour le copier")
                    .padding(.bottom, 10)
                HStack(spacing:20){
                    HStack {
                        Image(systemName: "link")
                            .resizable()
                            .scaledToFill()
                        .frame(width: 20, height: 20)
                        Text("blendr.bio/\(username)")
                            .onTapGesture {
                                UIPasteboard.general.string = "https://blendr.bio/\(username)"
                                showCopiedNotification = true
                                //changer l'état de showCopieNotification after deux seconde
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showCopiedNotification = false
                                }
                            }
                    }
                    
                    Spacer()
                    
                    //condition pour afficher la notification que le lien a bien été copier
                    if showCopiedNotification {
                        Image(systemName: "checkmark")
                            .foregroundColor(Color("color2"))

                    }else {
                        Text("Copier")
                            .font(.footnote)
                            .onTapGesture {
                                UIPasteboard.general.string = "https://blendr.bio/\(username)"
                                showCopiedNotification = true
                                //changer l'état de showCopieNotification after deux seconde
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showCopiedNotification = false
                                }
                            }
                    }
                    

                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.gray, lineWidth: 1)
                )
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .navigationTitle("Partage ton lien")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        dismiss()
                    } label: {
                       Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("color2"))
                    }
                   

                }
            }
        }
    }
}


#Preview {
    ShareLinkView( username: "undefined")
}
