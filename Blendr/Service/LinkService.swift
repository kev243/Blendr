//
//  LinkService.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import Foundation
import Supabase

class LinkService {
    
    static let shared = LinkService()
    
    private let supabase = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey)
    
    func uploadLinkInBd(  _ link: Link) async throws  {
        try await supabase.from("links").insert(link, returning: .representation).single().execute().value
        
    }
    
    func fetchAllMediaFromDB ()  async throws -> [Media] {
        let media:[Media] = try await supabase
            .from("media")
            .select()
            .execute()
            .value
        
        return media
    }
    
    func checkUsernameAvailable(username: String) async throws -> [User]  {
        let user: [User] = try await supabase
            .from("users")
            .select()
            .equals("username", value: username)
            .execute()
            .value
        
        
        return user
    }
    
    // Fonction pour récupérer les liens par userId
    func fetchLinksByUser(userId: String) async throws -> [Link] {
        let links: [Link] = try await supabase
            .from("links")
            .select()
            .equals("user_id", value : userId)
            .execute()
            .value
        
        return links
    }
    
    
   
    
    func updateLink( id: UUID ,name: String , username : String, status:Bool) async throws {
//        let linkId =  id.uuidString
      try await supabase
            .from("links")
            .update([
                "name": name,
                
                "username": username,
                
                "status": status ? "true" : "false"
            ])
            .equals("id", value: id.uuidString)
            .execute()
        
        
    }
    
    // Fonction pour supprimer un lien
    func deleteLink(linkId: UUID) async throws {
        try await supabase
            .from("links")
            .delete()
            .equals("id", value: linkId.uuidString)
            .execute()
    }
    
}
