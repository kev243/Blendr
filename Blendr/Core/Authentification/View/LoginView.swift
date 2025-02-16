//
//  LoginView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI
import PopupView

struct LoginView: View {
    @StateObject  var viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    

    var body: some View {
        NavigationStack{
            VStack(alignment:.leading,spacing: 10){
                
                //MARK: Title
                VStack (alignment:.leading, spacing: 5){
                    Text("Connexion")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("Veuillez remplir les champs ci-dessous pour vous connecter")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        
                }
                
                .padding(.bottom,15)
                
                //MARK: Champ formulaire
                VStack(alignment: .leading){
                    Text("Email")
                    
                    TextField("Entrer votre email" , text: $viewModel.email)
                        .font(.subheadline)
                        .padding(13)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                             RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                         )
                        
                }
                
                VStack(alignment: .leading){
                    Text("Mot de passe")
                    SecureField("Mot de passe" , text: $viewModel.password)
                        .font(.subheadline)
                        .padding(13)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                             RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                         )

                    
                }
                
                //MARK: Button forgot password
                NavigationLink {
                    ForgotPasswordView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Mot de passe oublié?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing)
                        .foregroundStyle(Color("color2"))
                }
                .frame(maxWidth: .infinity , alignment: .trailing)
                
                //MARK: Button Connexion
                Button {
                    Task{
                        
                        viewModel.logIn()

                    }
                } label: {
                    Text("Connexion")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .foregroundColor(.white)
                        .background(viewModel.isFormValid ? Color("color2") : .gray)
                        .cornerRadius(10)
                }
                .padding(.vertical)
                .disabled(!viewModel.isFormValid)
                
            }
            .onChange(of: viewModel.errorMessage){oldValue , newValue in
                showAlert = viewModel.errorMessage != nil
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding()
            
        
            Spacer()
            
            Text("Blendr")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
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
        .popup(isPresented: $showAlert  ) {
            PopupView(icon: "exclamationmark.triangle.fill", headline: "Erreur", subheadline: "Authentification invalide" , color: Color("Error"))
        } customize: { $0
            .type(.floater())
            .position(.top)
            .autohideIn(4)
            .animation(.spring())
            .closeOnTapOutside(true)
        }
   
    }
        
        
}

#Preview {
    LoginView()
}
