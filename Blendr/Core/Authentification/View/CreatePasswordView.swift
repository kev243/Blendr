//
//  CreatePasswordView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var passwordValid = false
    @State private var shouldNavigate = false
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing:10){
                Text("Créer un mot de passe")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Votre mot de passe doit avoir plus de 5 caractères")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                SecureField("Mot de passe" , text: $viewModel.password)
                    .font(.subheadline)
                    .padding(13)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.vertical,10)
                    .onChange(of: viewModel.password){oldValue , newValue in
                        passwordValid = viewModel.password.count > 5
                    }
                
                
                Button(action: {
                    shouldNavigate.toggle()
                }, label: {
                    Text("Continuer")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .foregroundColor(.white)
                        .background(passwordValid ? Color("color2") : .gray)
                        .cornerRadius(10)
                })
                .disabled(!passwordValid)
                
                Spacer()
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.top,20)
            .padding()
            .navigationTitle("Étapes 4/5")
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
            
            .navigationDestination(isPresented: $shouldNavigate) {
                CompleteSignUpView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        // Créez une instance de RegistrationViewModel pour l'utiliser comme environnement objet dans la preview
        let viewModel = RegistrationViewModel()
        
        // Injectez l'environnement objet temporaire dans la vue pour la preview
        return CreatePasswordView()
            .environmentObject(viewModel)
    }
}
