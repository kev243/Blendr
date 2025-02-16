//
//  AddUsernameView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI
import PopupView

struct AddUsernameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showAlertIsValid = false
    @State private var showAlertAvailable = false
    @State private var shouldNavigate = false
    @State private var isEmpty = false
    
    
    //    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing:10){
                Text("Créer un nom d'utilisateur")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Vous pourrez toujours le modifier plus tard dans vos paramètres.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                TextField("Entrer votre nom d'utilisateur" , text: $viewModel.username)
                    .font(.subheadline)
                    .padding(13)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.vertical,10)
                    .autocapitalization(.none) // Désactive la capitalisation automatique
                    .onChange(of: viewModel.username) { oldValue , newValue in
                        isEmpty = viewModel.isTextValid(viewModel.username)// on Vérifie si le champs est vide ou pas
                    }
                
                
                
                
                Button(action: {
                    Task {
                        try await  handleContinue()
                    }
                }) {
                    Text("Continuer")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .foregroundColor(.white)
                        .background( isEmpty ? Color("color2") : .gray  )
                        .cornerRadius(10)
                }
                .disabled(!isEmpty)
                
                
                
                Spacer()
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.top,20)
            .padding()
            .navigationTitle("Étapes 3/5")
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
            
            .popup(isPresented:  $showAlertIsValid) {
                PopupView(icon: "exclamationmark.triangle.fill", headline: "Username incorrect", subheadline: "Le username ne doit pas contenir des espaces.", color: Color("Error"))
            } customize: { $0
                .type(.floater())
                .position(.top)
                .autohideIn(4)
                .animation(.spring())
                .closeOnTapOutside(true)
            }
            
            
            .popup(isPresented:  $showAlertAvailable) {
                PopupView(icon: "exclamationmark.triangle.fill", headline: "Le username saisi existe déjà", subheadline: "Veuillez en créer un autre.", color: Color("Error"))
            } customize: { $0
                .type(.floater())
                .position(.top)
                .autohideIn(4)
                .animation(.spring())
                .closeOnTapOutside(true)
            }
            
            
        }
        .onAppear{
            isEmpty = viewModel.isTextValid(viewModel.username)
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            CreatePasswordView()
                .navigationBarBackButtonHidden(true)
        }
    }
    
    
    private func handleContinue() async throws {
        if viewModel.isValidUsername() {
            let isAvailable = try await viewModel.isUsernameAvailable()
            if isAvailable.isEmpty {
                shouldNavigate.toggle()
                
            } else {
                // Afficher un message d'erreur indiquant que l'username est déjà pris
                showAlertAvailable = true
            }
        } else {
            showAlertIsValid = true
        }
    }
}


struct AddUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        // Créez une instance de RegistrationViewModel pour l'utiliser comme environnement objet dans la preview
        let viewModel = RegistrationViewModel()
        
        // Injectez l'environnement objet temporaire dans la vue pour la preview
        return AddUsernameView()
            .environmentObject(viewModel)
    }
}





