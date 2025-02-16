//
//  UserService.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-07.
//

import Foundation
import Supabase

class UserService {
    @Published var currentUser:User?
    
    private let auth = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey).auth
    private let supabase = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey)
    static let shared = UserService()
    
    init(){
        Task{
            try await fetchUserFromDatabase()
        }
    }
    @MainActor
    func fetchUserFromDatabase() async throws -> User  {
        
        let uid =   try await auth.session.user.id.uuidString
        
        let response:User = try await supabase
            .from("users")
            .select()
            .equals("id", value: uid)
            .single()
            .execute()
            .value
 
        
        self.currentUser = response
    
        
        return response
        
    }
    
    func createdUserInDatabase (_ user: User) async throws {
        let _ : User =  try await supabase.from("users").insert(user, returning: .representation).single().execute().value
    
    }
    

    //function pour reset le currentUser apres deconecxion
    func reset() {
        self.currentUser = nil
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
    
    func checkEmailExistInDatabase(email:String) async throws -> [User] {
        let user: [User] = try await supabase
            .from("users")
            .select()
            .equals("email", value: email)
            .execute()
            .value
        
        
        return user
    }
    
    func updateUser(fullname: String ,username: String , bio: String  )async throws{
        let uid =   try await auth.session.user.id.uuidString
        try await supabase.from("users").update(["fullname" : fullname , "username" : username , "bio" : bio])
            .equals("id", value: uid)
            .execute()
        
        _ = try await fetchUserFromDatabase()
    }
    
    
    @MainActor
    func updateUserPrivacy(status: Bool) async throws {
        let uid =   try await auth.session.user.id.uuidString
        try await supabase.from("users").update([
            "is_private": status
        ])
        .equals("id", value: uid)
        .execute()
        
//        self.currentUser = try await fetchUserFromDatabase()
    }
    
    func updateUserProfileImage(imageUrl: String) async throws {
        let uid =   try await auth.session.user.id.uuidString
        _ = try await supabase
            .from("users")
            .update([
                "profile_image_url": imageUrl,
            ])
            .equals("id", value: uid)
            .execute()
        
        self.currentUser?.profileImageUrl = imageUrl
    }
    
    func sendPasswordUserReset(email: String) async throws {
try await auth.resetPasswordForEmail(email)
       
        
    }
}
