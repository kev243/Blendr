//
//  SignInViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-28.
//

import Foundation
import GoogleSignIn

class SignInViewModel: ObservableObject {
    let signInGoogle = SignInGoogle()
    func signInWithApple() {
        
    }
    
    @MainActor
    func signInWithGoogle()async throws{
       try await signInGoogle.startSignInGoogle()
    }
}
