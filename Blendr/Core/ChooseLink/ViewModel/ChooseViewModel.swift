//
//  ChooseViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import Foundation
import Supabase


class ChooseViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var media:[Media]=[]
    @Published var linkCreated:Link?
    @Published var created = false
    private let auth = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey).auth
    
    init(){

    }
    
    
    func uploadLink(name: String, username: String, imageUrl: String, url: String) async throws {
         do {
    let uid = try await auth.session.user.id.uuidString
             

             let link = Link(id: UUID(), name: name, imageUrl: imageUrl, url: url, username: username, userId: uid, type: "Media social", status: true, createdAt: .now)

             try await LinkService.shared.uploadLinkInBd(link)
             try await ProfileViewModel.shared.fetchUserLinks()
         } catch {
             print("Erreur lors du téléchargement du lien : \(error)")
             // Vous pouvez ajouter ici d'autres actions à effectuer en cas d'erreur (par exemple, afficher une alerte à l'utilisateur)
         }
     }
    
    // Fonction pour récupérer les logos depuis le serveur
    @MainActor
    func fetchAllMedia() async throws {
        
        self.media = try await LinkService.shared.fetchAllMediaFromDB()
        
    }
    
    var filteredMedia: [Media] {
        if searchText.isEmpty {
            return media
        } else {
            return media.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}


