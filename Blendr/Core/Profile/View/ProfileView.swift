//
//  ProfileView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import SwiftUI


struct ProfileView: View {
    @StateObject private var viewModel  = ProfileViewModel()
    @State private var isPresented = false
    @State private var isShowingShareLink = false
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private var currentUser: User? {
        return viewModel.currentUser
        
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // MARK: Profile
                    VStack(spacing: 10) {
                        CircularProfileImageView(user: currentUser ?? User.MOCK_USER)
                        Text(currentUser?.username ?? "kevin_nimi")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        
                        Text(currentUser?.bio ?? "")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        
                        
                        if viewModel.userLinks.isEmpty {
                            VStack {
                                Text("Vous avez encore aucun lien, veuillez cliquez sur le button pour créer")
                                    .multilineTextAlignment(.center)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding()
                                
                                NavigationLink {
                                    ChooseLinkView()
                                } label: {
                                    Image(systemName: "plus")
                                        .padding()
                                        .background(Color("color2"))
                                        .clipShape(Circle())
                                        .foregroundColor(.white)
                                }
                            }
                        }else {
                            LazyVGrid (columns: columns){
                                ForEach(viewModel.userLinks){ link in
                                    NavigationLink {
                                        EditProfileLinkView(link: link)
                                            .navigationBarBackButtonHidden(true)
                                    } label: {
                                        ProfilLinkCell(link: link)
                                        
                                    }
                                    .tint(Color.primary)
                                }
                            }
                            .padding(.vertical, 20)
                        }
                    }
                    .padding()
                }
            }
            
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Blendr")
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            // Action pour le bouton "eye"
                        }) {
                            Image(systemName: "eye")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                                .foregroundColor(.primary)
                        }
                        
                        Button(action: {
                            isShowingShareLink.toggle()
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingShareLink, content: {
                ShareLinkView( username: currentUser?.username ?? "undefined")
                    .presentationDetents([.height(300),.large])
            })
            .onAppear {
                Task {
                    try await viewModel.fetchUserLinks()
                }
            }
                        
        }
    }
}

#Preview {
    NavigationStack{
        ProfileView()
    }
}
