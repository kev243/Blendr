//
//  EditProfileLinkView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-15.
//

import SwiftUI
import Kingfisher

struct EditProfileLinkView: View {
    var link: Link
    @State private var name: String
    @State private var username: String
    @State private var isLoading = false
    @State private var isLoadingTrash = false
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = EditProfilLinkViewModel()
    
    init(link: Link) {
        self.link = link
        _name = State(initialValue: link.name)
        _username = State(initialValue: link.username)
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Icon reseaux
                KFImage(URL(string: link.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                
                EditProfileRowView(title: "Nom", placeholder: link.name, text: $name)
                EditProfileRowView(title: "Nom d'utilisateur", placeholder: link.username, text: $username)
                
                HStack{
                    Button {
                        Task{
                            isLoadingTrash = true
                            try await viewModel.deleteLink(linkId: link.id)
                            isLoadingTrash = false
                            dismiss()
                            
                        }
                        
                    } label: {
                        if isLoadingTrash {
                         ProgressView()
                                .padding()
                                .background(.red)
                                .cornerRadius(10)
                        } else{
                            Image(systemName: "trash")
                                .padding()
                                .foregroundColor(.white)
                                .background(.red)
                                .cornerRadius(10)
                        }

                    }
                    .disabled(isLoading)
                    .disabled(isLoadingTrash)
                    .padding(.vertical)
                    
                    Button {
                        
                        Task{

                            isLoading = true
                            try await saveChanges()
                            isLoading = false
                            dismiss()

                        }
                        
                    } label: {
                        if isLoading {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .background(Color("color2").opacity(0.7))
                                .cornerRadius(10)
                        } else {
                            Text("Enregistrer")
                                .padding()
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .background(Color("color2"))
                                .cornerRadius(10)
                        }
                        
                    }
                    .disabled(isLoading)
                    .disabled(isLoadingTrash)
                    
                    .padding(.vertical)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Modifier le lien")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        Task {
                            dismiss()
                        }
                    }
                    .disabled(isLoading)
                    .font(.subheadline)
                    .foregroundColor(Color("color2"))
                }
                
                
            }
        }
    }
    
    private func saveChanges() async throws {
        try await viewModel.updateLink(id: link.id, name: name, username: username, status: true)
    }
    
}


#Preview {
    EditProfileLinkView(link: Link.MOCK_LINK)
}
