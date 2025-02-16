//
//  RegistrationViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import Foundation
class RegistrationViewModel: ObservableObject {
    @Published var fullname = ""
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    
    
    func createNewAccount(){
        Task {
            do {
                let lowercaseUsername = username.lowercased()
                let user = User(fullname: fullname, email: email, username: lowercaseUsername, isPrivate: false,createdAt: .now)
                try await AuthService.shared.registerNewUserWitchEmail(user: user,  password: password)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func isValidUsername() -> Bool {
        // Vérifie s'il y a des espaces blancs dans le nom d'utilisateur
        guard username.rangeOfCharacter(from: .whitespaces) == nil else {
            return false // Le nom d'utilisateur contient des espaces blancs
        }
        
        // Vérifie si la longueur du nom d'utilisateur est supérieure à 3 caractères
        guard username.count > 3 else {
            return false // Le nom d'utilisateur est trop court
        }
        
        return true // Le nom d'utilisateur est valide
    }
    
    //pour vérifier si le texte n'est pas vide.
    func isTextValid(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).count > 4
     }
    
    func isValidEmail() -> Bool {
        // Expression régulière pour valider le format de l'email
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isUsernameAvailable() async throws -> [User]  {
        let lowercaseWord = username.lowercased()
       let response =  try await UserService.shared.checkUsernameAvailable(username: lowercaseWord)
        return response
    
    }
    
    func userExist() async throws -> [User] {
        let lowercaseEmail = email.lowercased()
        let response = try await UserService.shared.checkEmailExistInDatabase(email: lowercaseEmail)
        return response
    }
}





