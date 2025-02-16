//
//  LoginViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import Foundation

@MainActor
class LoginViewModel:ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    // Vérifie si l'email est valide en utilisant une expression régulière
      var isEmailValid: Bool {
          // Expression régulière pour valider le format de l'email
          let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
          let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
          return emailPredicate.evaluate(with: email)
      }
    



      // Vérifie si le mot de passe contient plus de 5 caractères
      var isPasswordValid: Bool {
          return password.count > 5
      }

      // Vérifie si le formulaire est valide en combinant les vérifications de l'email et du mot de passe
      var isFormValid: Bool {
          return isEmailValid && isPasswordValid
      }
    
    func logIn (){
        Task {
            do {
                self.errorMessage = nil
                let lowercaseEmail = email.lowercased()
                _ =   try await AuthService.shared.signIn(email: lowercaseEmail, password: password)
                               
            } catch{
               // print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
}
