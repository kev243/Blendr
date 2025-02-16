//
//  addEmailView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI
import PopupView

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isEmailValid = false
    @State private var shouldNavigate = false
    @State private var showAlertUserExist = false
    @State private var showAlertEmailValid = false
    
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing:10){
                Text("Email")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Vous allez l'utiliser pour vous connecter à votre compte.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                TextField("Entrer votre email" , text: $viewModel.email)
                    .modifier(TextFieldStyle())
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.email) { oldValue , newValue in
                        isEmailValid = viewModel.isValidEmail() // on Vérifie si l'email est valide lorsqu'il change
                    }
                
                Button(action: {
                    Task {
                        try await handleContinue()
                    }
                    
                }) {
                    Text("Continuer")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .foregroundColor(.white)
                        .background(isEmailValid ? Color("color2") : .gray)
                        .cornerRadius(10)
                }
                .disabled(!isEmailValid)
                
                Spacer()
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.top,20)
            .padding()
            .navigationTitle("Étapes 2/5")
            .navigationBarTitleDisplayMode(.inline)
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
        .popup(isPresented:  $showAlertUserExist) {
            PopupView(icon: "exclamationmark.triangle.fill", headline: "Un compte existe déjà avec cet email", subheadline: "Veuillez en choisir un autre pour continuer.", color: Color("Error"))
        } customize: { $0
            .type(.floater())
            .position(.top)
            .autohideIn(4)
            .animation(.spring())
            .closeOnTapOutside(true)
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            AddUsernameView()
                .navigationBarBackButtonHidden(true)
        }
    }
    
    private func handleContinue() async throws {
        if viewModel.isValidEmail() {
            let userExist = try await viewModel.userExist()
            //si aucun utilisateur est retourner
            if userExist.isEmpty {
                shouldNavigate.toggle()
                
            } else {
                // Afficher un message d'erreur indiquant que le compte existe déjà
                showAlertUserExist.toggle()
            }
        } else {
            showAlertEmailValid.toggle()
        }
    }
    
}

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        // Créez une instance de RegistrationViewModel pour l'utiliser comme environnement objet dans la preview
        let viewModel = RegistrationViewModel()
        
        // Injectez l'environnement objet temporaire dans la vue pour la preview
        return AddEmailView()
            .environmentObject(viewModel)
    }
}
