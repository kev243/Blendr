//
//  EditProfilLinkView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-17.
//

import Foundation

@MainActor
class EditProfilLinkViewModel: ObservableObject {
    static let shared = EditProfilLinkViewModel()
    
    // Met à jour un lien
    func updateLink(id: UUID, name:String, username: String , status: Bool) async throws {
        try await LinkService.shared.updateLink(id: id, name: name, username: username, status: status)
        try await ProfileViewModel.shared.fetchUserLinks()
    }
    
    // Supprime un lien
    func deleteLink(linkId: UUID) async throws {
        try await LinkService.shared.deleteLink(linkId: linkId)
        ProfileViewModel.shared.userLinks.removeAll { $0.id == linkId }
      
    }
}
