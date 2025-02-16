//
//  ForgotPasswordView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI
import PopupView

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()
    @State private var forgotPassword = ""
    @State private var isEmailValid = false
    @State private var showAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing:10){
                Text("Mot de passe oublié")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                Text("Nous vous enverrons un lien de réinitialisation de votre mot de passe sur l'adresse email que vous avez saisie lors de votre première connexion.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                TextField("Email" , text: $viewModel.email)
                    .font(.subheadline)
                    .padding(13)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.vertical,10)
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.email) { oldValue , newValue in
                        isEmailValid = viewModel.isValidEmail() // on Vérifie si l'email est valide lorsqu'il change
                    }

               Button {
                   Task{
                       
                       try await viewModel.sendPasswordReset()
                   }
                       
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 44)
                            .foregroundColor(.white)
                            .background( Color("color2") )
                            .cornerRadius(10)
                    }else{
                        Text("Envoyer les instrutions")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 44)
                            .foregroundColor(.white)
                            .background(isEmailValid ? Color("color2") : .gray)
                            .cornerRadius(10)
                    }

                }
                .disabled(!isEmailValid)

                Spacer()
            }
            .onChange(of: viewModel.errorMessage){oldValue , newValue in
                showAlert = viewModel.errorMessage != nil
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.top,20)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .padding(13)
                        .background(Color(.systemGray6))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .imageScale(.large)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
        .onAppear{
            isEmailValid = viewModel.isValidEmail()
        }
        .popup(isPresented: $showAlert  ) {
            PopupView(icon: "exclamationmark.triangle.fill", headline: "Erreur", subheadline: "Aucun compte existant avec l'email saisie", color: Color("Error"))
        } customize: { $0
            .type(.floater())
            .position(.top)
            .autohideIn(4)
            .animation(.spring())
            .closeOnTapOutside(true)
        }
        
        .popup(isPresented: $viewModel.instructionSend  ) {
            PopupView(icon: "checkmark", headline: "Instructions envoyées", subheadline: "Consultez votre boîte e-mail ", color: .green)
        } customize: { $0
            .type(.floater())
            .position(.top)
            .autohideIn(5)
            .animation(.spring())
            .closeOnTapOutside(true)
        }
    }
}

#Preview {
    ForgotPasswordView()
}
