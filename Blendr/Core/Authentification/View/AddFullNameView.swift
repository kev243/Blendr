//
//  AddFullNameView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI

struct AddFullNameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var shouldNavigate = false
    @State private var isFullnameValid = false
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading , spacing:10){
                Text("Comment vous appelez-vous?")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                Text("Entrer votre nom complet")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                TextField("Kevin Nimi" , text: $viewModel.fullname)
                    .modifier(TextFieldStyle())
                    .disableAutocorrection(true) // Désactive les suggestions de texte
                 
                    .onChange(of: viewModel.fullname){oldValue , newValue in
                        isFullnameValid = viewModel.fullname.trimmingCharacters(in: .whitespacesAndNewlines).count > 3
                    }
                
                
                Button(action: {
                    shouldNavigate.toggle()
                }) {
                    Text("Continuer")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 44)
                        .foregroundColor(.white)
                        .background(isFullnameValid ? Color("color2") : Color.gray)
                    
                        .cornerRadius(10)
                }
                .disabled(!isFullnameValid)
            }
            
            
            Spacer()
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding(.top,20)
        .padding()
        .navigationTitle("Étapes 1/5")
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
            AddEmailView()
                .navigationBarBackButtonHidden(true)
        }
        
        .onAppear{
            isFullnameValid = viewModel.fullname.trimmingCharacters(in: .whitespacesAndNewlines).count > 3
        }
    }
    
}


struct AddFullNameView_Previews: PreviewProvider {
    static var previews: some View {
        // Créez une instance de RegistrationViewModel pour l'utiliser comme environnement objet dans la preview
        let viewModel = RegistrationViewModel()
        
        // Injectez l'environnement objet temporaire dans la vue pour la preview
        return AddFullNameView()
            .environmentObject(viewModel)
    }
}
