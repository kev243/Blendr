//
//  LoginView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isShowingLogin = false
    @StateObject var viewModel = SignInViewModel()
//    let signInApple = SignInApple()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color("color1")
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    //MARK: Logo welcome
                    Text("Blendr")
                        .foregroundStyle(.white)
                        .font(.system(size: 20,weight: .bold))
                    Spacer()
                    
                    VStack(spacing:40){
                        //MARK: Image welcome
                        Image( "insta")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200 ,height: 200)
                        
                        //MARK: Slogan
                        Text("Rassemblez vos profils sociaux dans un seul lien")
                            .foregroundStyle(.white)
                            .font(.system(size: 30,weight: .bold))
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    Spacer()
                    
                    //MARK: Button action
                    VStack{
                        //MARK: Sign gmail
                        Button{
                            Task {
                                try await viewModel.signInWithGoogle()
                            }
                                
                        } label: {
                            HStack{
                                Image("google")
                                    .resizable()
                                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                    .frame(width: 20 , height: 20)
                               
                                Text("Connectez-vous avec Google")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal)
                                   
                            }
                            .frame(width: 360, height: 50)
                            .background(.white)
                            .cornerRadius(20)
                        }
                        
                        
                        
                        //MARK: Sign in Appel
                        Button{
//                            signInApple.startSignInWithAppleFlow { result in
//                                switch result {
//                                case .success(let appleResult) :
//                                    Task{
//                                       try await AuthService.shared.signInWithAppel(idToken: appleResult.idToken, nonce: appleResult.nonce)
//                                    }
//                                case .failure(_):
//                                    print("error")
//                                }
//                            }
                                
                        } label: {
                            HStack{
                                Image("appel")
                                    .resizable()
                                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                    .frame(width: 25 , height: 25)
                               
                                Text("Connectez-vous avec Appel")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                    .padding(.horizontal)
                                   
                            }
                            .frame(width: 360, height: 50)
                            .background(.white)
                            .cornerRadius(20)
                        }
                        .padding(.vertical, 5)

                    }
                    
                    
                }
                
            }
            
        }
        
        .sheet(isPresented: $isShowingLogin, content: {
            LoginView()
            
        })
    }
}

#Preview {
    WelcomeView()
}
















//                        NavigationLink{
//                            AddFullNameView()
//                                .navigationBarBackButtonHidden(true)
//                        } label: {
//                            Text("Commencer")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .frame(width: 360, height: 46)
//                                .foregroundColor(.black)
//                                .background(.white)
//                                .cornerRadius(20)
//                        }
//                        .padding(.vertical, 5)
                        
                        
//                        Button{
//                            isShowingLogin.toggle()
//                        } label: {
//                            Text("Connexion")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//                                .frame(width: 360, height: 46)
//                                .foregroundColor(.white)
//                        }
//
//                        .padding(.vertical, 5)
