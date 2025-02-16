//
//  EditProfilView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-18.
//

import SwiftUI
import PhotosUI
import PopupView

struct EditProfileView: View {
    let user:User
    @State private var fullname = ""
    @State private var username = ""
    @State private var bio = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss
    @State private var showAlertIsValid = false
    @StateObject var viewModel = EditProfileViewModel()
    
    init(user: User) {
        self.user = user
        _fullname = State(initialValue: user.fullname)
        _username = State(initialValue: user.username)
        _bio = State(initialValue: user.bio ?? "text")
    }
    
    var body: some View {
        NavigationStack{
            VStack(){
                PhotosPicker(selection: $viewModel.selectedItem) {
                    if let image = viewModel.profilImage {
                        VStack(spacing:10){
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 70, height: 70)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            
                            Text("Modifier votre profil")
                                .font(.footnote)
                                .foregroundColor(Color("color2"))
                                .fontWeight(.semibold)
                        }
                        
                    }else{
                        VStack (spacing:10){
                            CircularProfileImageView(width: 70, height: 70, user: user)
                            Text("Modifier votre profil")
                                .font(.footnote)
                                .foregroundColor(Color("color2"))
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                Divider()
                
                    .padding(.vertical,10)
                
                
                VStack(alignment:.leading){
                    EditProfileRowView(title: "Nom", placeholder: user.fullname,  text: $fullname)
                    EditProfileRowView(title: "Nom d'utilisateur", placeholder: user.username,  text: $username)

                    
                    HStack (alignment:.top){
                        Text("bio")
                            .padding(.leading,8)
                            .frame(width: 120,alignment: .leading)
 
                        VStack (alignment:.trailing){
                            TextEditor(text: $bio)
                                .frame(height: 70)
                            Divider()
                        }
                        
                    }
                    .padding(.horizontal,4)
                    
                }
                .padding(.horizontal,4)
            }
            .padding(.top, 10)
            
            
            Spacer()
        }
        .navigationTitle("Modifier le profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Annuler"){
                    dismiss()
                    
                }
                .disabled(isLoading)
                .font(.subheadline)
                .foregroundColor(Color("color2"))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        isLoading = true
                        
                      try  await handleContinue()
                        isLoading = false
                        if !showAlertIsValid{
                            dismiss()
                        }
                     
                    }
                    
                }, label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Enregistrer")
                    }
                })
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color("color2"))
                
            }
            
          
        }
        .popup(isPresented:  $showAlertIsValid) {
            PopupView(icon: "exclamationmark.triangle.fill", headline: "Le username saisi existe déjà", subheadline: "Veuillez en créer un autre.", color: Color("Error"))
        } customize: { $0
            .type(.floater())
            .position(.top)
            .autohideIn(4)
            .animation(.spring())
            .closeOnTapOutside(true)
        }
        
    }
    
    private func handleContinue() async throws{
        do {
            // Vérifiez si le nom d'utilisateur a changé
               if username != user.username {
                   // Vérifiez si le nouveau nom d'utilisateur est disponible
                   let isUsernameTaken = try await viewModel.isUsernameAvailable(username: username)
                   
                   if !isUsernameTaken.isEmpty {
                       showAlertIsValid = true
                       return
                   }
               }
            
            if viewModel.uiImage != nil {
                try await viewModel.updateProfilImage()
                try await viewModel.updateUserProfil(username: username, fullname: fullname , bio: bio)
            } else{

                try await viewModel.updateUserProfil(username: username, fullname: fullname , bio: bio)

            }
        }
    }
    

}



#Preview {
    NavigationStack{
        EditProfileView(user: User.MOCK_USER)
    }
}
