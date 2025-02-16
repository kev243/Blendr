//
//  CompleteSignUpView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI

struct CompleteSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    var body: some View {
        NavigationStack{
            ZStack{
                Color("color4")
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Image("main")
                    
                    VStack(spacing:10){
                        Text("Bienvenue sur Blendr,\(viewModel.username)")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Cliquez ci-dessous pour terminer l'inscription et commencer à utiliser Blendr")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,24)
                    }
                    Button{
                        Task{
                            viewModel.createNewAccount()
                        }
                    } label: {
                        Text("Terminer l'inscription")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 44)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                    
                    Spacer()
                    
                }
            }
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
    }
}

struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        // Créez une instance de RegistrationViewModel pour l'utiliser comme environnement objet
        let viewModel = RegistrationViewModel()
        
        // Injectez l'environnement objet dans la vue
        return CompleteSignUpView()
            .environmentObject(viewModel)
    }
}

