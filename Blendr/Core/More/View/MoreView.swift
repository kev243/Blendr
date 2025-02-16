//
//  MoreView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-18.
//

import SwiftUI
import CoreNFC

struct MoreView: View {
    
    @State private var isPrivateToggleOn = false
    @StateObject var viewModel = SettingsViewModel()
    @State var write = NFCReader()
   
    
    private var currentUser: User?{
          return viewModel.currentUser
      }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        EditProfileView(user: currentUser ?? User.MOCK_USER)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack(spacing:10) {
                            CircularProfileImageView(width: 70, height: 70, user: currentUser ?? User.MOCK_USER)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentUser?.username ?? User.MOCK_USER.username)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(currentUser?.email ?? User.MOCK_USER.email)
                                    .font(.footnote)
                                    .accentColor(.gray)
                            }
                        }
                    }

                }
                
                Section("Compte") {
                    Toggle(isOn: $viewModel.isPrivateToggleOn) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "lock")
                                Text("Mode privé")
                            }
                            Text("Rendez votre profil blendr privé au public")
                                .font(.footnote)
                                .foregroundStyle(.gray.opacity(0.7))
                        }
                    }
                    
                    Button {
                        let username = currentUser?.username ?? ""
                        write.scan(theactualdata: "https://blendr-app.vercel.app/\(username)")
                    } label: {
                        HStack{
                            Image(systemName: "sensor.tag.radiowaves.forward")
                                .imageScale(.small)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.primary)
                             
                            
                            Text("Active ton tag")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }

                }
                
                Section("Zone dangereuse") {
                    Button {
                        Task {
                            try await AuthService.shared.signOut()
                        }
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Déconnexion", tintColor: .red)
                    }
                    
                    Button {
                        print("Supprimer le compte")
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                    }
                }
            }
           
            .navigationTitle("Paramètres")
        }
        
    }
}


#Preview {
    NavigationStack{
        MoreView()
    }
}


