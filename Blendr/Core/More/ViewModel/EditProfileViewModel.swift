//
//  EditProfileViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-18.
//

import Foundation
import PhotosUI
import SwiftUI

class EditProfileViewModel: ObservableObject {
    
    
    @Published var profilImage:Image?
    @Published  var uiImage: UIImage?
    @Published var selectedItem:PhotosPickerItem?{
        didSet {Task { await loadImage()}}
    }
    
    //function pour recuperer une image
    @MainActor
    private func loadImage() async {
        // Vérifie s'il y a un élément sélectionné
        guard let item = selectedItem else {return}
        
        // Tente de charger les données transférables à partir de l'élément sélectionné
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        
        // Convertit les données en UIImage, si possible
        guard let uiImage = UIImage(data: data) else {return}
        
        // Met à jour les propriétés de l'image avec l'image chargée
        self.uiImage = uiImage
        self.profilImage = Image(uiImage: uiImage)
    }
    
    
    //function pour mettre à jour le name et le username de l'utilisateur
    func updateUserProfil(username: String, fullname: String , bio: String) async throws {
        do {
            // Supprimer les espaces dans le nom d'utilisateur
            let trimmedUsername = username.lowercased().replacingOccurrences(of: " ", with: "")
            try await UserService.shared.updateUser(fullname: fullname, username: trimmedUsername, bio: bio)
        } catch{
            print( "Erreur lors de la mise à jour du document : \(error.localizedDescription)")
        }
    }
    
    func isUsernameAvailable(username: String) async throws -> [User] {
        // Convertir le nom d'utilisateur en minuscules et supprimer les espaces
        let cleanedUsername = username.lowercased().replacingOccurrences(of: " ", with: "")
        // Vérifier si le nom d'utilisateur est disponible
        let response = try await UserService.shared.checkUsernameAvailable(username: cleanedUsername)
        return response
    }
    
    //function pour mettre a jour la photo de profil du user
    func updateProfilImage() async throws {
        guard let image = self.uiImage else {return}
        guard let imageUrl = try await ImageUploader.shared.uploadImage(image) else {return}
        try await UserService.shared.updateUserProfileImage(imageUrl: imageUrl)
    }
}
