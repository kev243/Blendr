//
//  SignInGoogle.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-28.
//

import Foundation
import UIKit
import GoogleSignIn
import CryptoKit



class SignInGoogle {
    
    func startSignInGoogle() async throws {
        guard let topVC = await Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        // Utilisationdu  DispatchQueue.main.async pour appeler signIn sur le thread principal
        let gidSignInResult: GIDSignInResult = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance.signIn(withPresenting: topVC) { result, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let result = result {
                        continuation.resume(returning: result)
                    }
                }
            }
        }
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        // Récupérer les informations de l'utilisateur
        let user = gidSignInResult.user
        let fullName = user.profile?.name ?? "no-name"
        let emailAddress = user.profile?.email ?? "no-email"
        
        // Créer un nom d'utilisateur en utilisant l'email ou le nom complet
        let username = generateUsername(email: emailAddress, fullName: fullName)
        
        //creation du user
        let userInfo = User( fullname: fullName, email: emailAddress, username: username, createdAt: .now)

        let accessToken = gidSignInResult.user.accessToken.tokenString
 
        try await AuthService.shared.signInWithGoogle(idToken: idToken, accessToken: accessToken, user: userInfo)
    }
    
    private func generateUsername(email: String, fullName: String) -> String {
          // Générer un nom d'utilisateur à partir de l'email ou du nom complet
          let baseUsername: String
          if !fullName.isEmpty {
              baseUsername = fullName.replacingOccurrences(of: " ", with: ".").lowercased()
          } else {
              baseUsername = email.components(separatedBy: "@").first ?? "user"
          }
          
          // Ajouter des chiffres aléatoires au nom d'utilisateur
          let randomNumbers = String(Int.random(in: 1000...9999))
          return "\(baseUsername)\(randomNumbers)"
      }
}

