//
//  AuthService.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import Supabase
import Foundation


enum Secrets {
    //Key
    static let supabaseURL = "https://qqsrnhkthvtlytpjwmem.supabase.co"
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFxc3JuaGt0aHZ0bHl0cGp3bWVtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTc2MzUzNjIsImV4cCI6MjAzMzIxMTM2Mn0.9cjlAITRlHmiKfazVlZfIVK_7YMd18HlTw7M_F5dMJg"
}


@MainActor
class AuthService {
    @Published var userSession: Supabase.User?
    static let shared = AuthService()
    @Published var currentUser: User?
    @Published var errorExist = false
    @Published var errorMessage:String?
    
    private let auth = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey).auth
    private let supabase = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey)
    
    init(){
        Task{
            self.userSession = try await auth.session.user
            _ = try await UserService.shared.fetchUserFromDatabase()
        }
    }
    

    func signInWithAppel(idToken: String, nonce:String) async throws{
        let creds = OpenIDConnectCredentials(provider: .apple, idToken: idToken , nonce: nonce)
        _ = try await auth.signInWithIdToken(credentials: creds)
    }
    
    @MainActor
    func signInWithGoogle(idToken:String,accessToken:String,user:User) async throws  {
        // Vérifier si l'utilisateur existe déjà dans la base de données
        let userExists = try await UserService.shared.checkEmailExistInDatabase(email: user.email)

        if !userExists.isEmpty {
            // Si l'utilisateur existe, on effectue la connexion
            try await signInExistingUser(idToken: idToken, accessToken: accessToken)
        } else {
            // Si l'utilisateur n'existe pas, on créer un nouvel utilisateur
            try await registerNewUser(idToken: idToken, accessToken: accessToken, user: user)
        }
    }
    
    
    // Fonction pour connecter un utilisateur existant
    @MainActor
    private func signInExistingUser(idToken: String, accessToken: String) async throws {
        do {
            self.userSession = try await auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .google,
                    idToken: idToken,
                    accessToken: accessToken
                )
            ).user
            
            _ = try await UserService.shared.fetchUserFromDatabase()
        } catch {
            // Gérer l'erreur de connexion
            print("Failed to sign in existing user: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Fonction pour enregistrer un nouvel utilisateur
    @MainActor
    private func registerNewUser(idToken: String, accessToken: String, user: User) async throws {
        do {
            self.userSession = try await auth.signInWithIdToken(
                credentials: OpenIDConnectCredentials(
                    provider: .google,
                    idToken: idToken,
                    accessToken: accessToken
                )
            ).user
            

            try await UserService.shared.createdUserInDatabase(user)
            _ = try await UserService.shared.fetchUserFromDatabase()
        } catch {
            // Gérer l'erreur d'enregistrement de l'utilisateur
            print("Failed to register new user: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func signIn(email:String,password:String) async throws -> User {
        do{
            self.userSession = try await auth.signIn(email: email, password: password).user
            let result = try await UserService.shared.fetchUserFromDatabase()
            return result
            
        }catch {
            throw error
        }
        
    }
    
    
    @MainActor
    func registerNewUserWitchEmail(user:User,password:String) async throws{
        
        do {
            let response = try await auth.signUp(email: user.email, password: password)
            self.userSession = response.session?.user
            try await UserService.shared.createdUserInDatabase(user)
            _ = try await UserService.shared.fetchUserFromDatabase()
            
        } catch  {
            print("DEBUG: Login user \(error.localizedDescription)")
        }
    }
    
    
    @MainActor
    func signOut () async throws {
        try await auth.signOut()
        self.userSession = nil
         UserService.shared.reset()
    }
    
}


