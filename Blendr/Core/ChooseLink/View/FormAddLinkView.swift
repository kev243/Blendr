//
//  FormAddLinkView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-13.
//

import SwiftUI

struct FormAddLinkView: View {
    @StateObject  var viewModel = ChooseViewModel()
    @Environment(\.dismiss) var dismiss
    var media:Media
    @State  var name:String
    @State  var username = ""
    @State private var showNotification = false
    @State private var isLoading = false
    
    init(media: Media) {
        self.media = media
        _name = State(initialValue: media.name) // Initialisez la variable d'état name avec la valeur du nom du logo
    }
    
    
    var body: some View {
        NavigationStack{
            List{
                VStack(alignment:.leading){
                    TextField("Texte du lien", text: $name)
                    Divider()
                    TextField("Nom d'utilisateur", text: $username)
                        .autocapitalization(.none) // Désactive la capitalisation automatique
                        .keyboardType(.alphabet) // Définit le type de clavier sur alphabétique
                        
                        
                }
            }
        }
        
        .navigationTitle("Nouveau lien")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Annuler"){
                    dismiss()
                }
                .font(.subheadline)
                .foregroundColor(Color("color2"))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        isLoading = true
                        try await addLinkButtonTapped()
                        isLoading = false
                        dismiss()
                        
                    }
                } label: {
                    if isLoading { // Afficher le loader si isLoading est true
                        ProgressView()
                    } else {
                        Text("Enregistrer")
                    }
                }
                .font(.subheadline)
                .opacity(username.isEmpty ? 0.5 : 1.0)
                .disabled(username.isEmpty)
                .foregroundColor(Color("color2"))
            }
            
        }
    }
    private func addLinkButtonTapped() async throws {
        
        try await viewModel.uploadLink(name:name, username:username, imageUrl:media.imageUrl,url:media.url)
        
        
        //        try await ProfileViewModel.shared.fetchUserLinks()
        
    }
}


#Preview {
    NavigationStack{
        FormAddLinkView(media: Media(id: UUID(), name: "Threads", type: "Social media", imageUrl: "https://res.cloudinary.com/dhwfhmngb/image/upload/v1714623740/threads_hvkxqq.png", url: "https://www.tiktok.com/"))
        
    }
}

