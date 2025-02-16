//
//  ForgotPasswordViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-24.
//

import Foundation

@MainActor
class ForgotPasswordViewModel:ObservableObject {
    
    @Published var email: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var instructionSend: Bool = false
    
    func isValidEmail() -> Bool {
        // Expression régulière pour valider le format de l'email
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func sendPasswordReset() async throws {

        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await UserService.shared.checkEmailExistInDatabase(email: email)
            
            if response.isEmpty {
                isLoading = false
                return errorMessage = "Aucun compte existant avec l'email saisie"
            }
            
            try await UserService.shared.sendPasswordUserReset(email: email)
            isLoading = false
            instructionSend = true
        } catch {
            isLoading = false
            instructionSend = false
            errorMessage = "Erreur lors de l'envoi de l'email de réinitialisation"
            print(error.localizedDescription)
        }
        
        
    }
}
