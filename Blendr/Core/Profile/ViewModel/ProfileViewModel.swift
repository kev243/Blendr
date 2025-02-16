//
//  ProfilViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-15.
//

import Foundation
import Supabase
import Combine

//@MainActor
class ProfileViewModel: ObservableObject {
    private let auth = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey).auth
  
    static let shared = ProfileViewModel()
    @Published var userLinks: [Link] = []
    

  
    @Published var currentUser: User? {
           didSet {
               if currentUser != nil {
                   Task {
                       do {
                           try await fetchUserLinks()
                       } catch {
                           print("Error fetching user links: \(error)")
                       }
                   }
               }
           }
       }
    
    init() {
         setupSubscribers()
     }
    
    private var cancellables = Set<AnyCancellable>()
    
    
    private func setupSubscribers(){
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in:&cancellables)
    }
    
    @MainActor
    func fetchUserLinks() async throws {
        
        let userId =   try await auth.session.user.id.uuidString
        let response = try await LinkService.shared.fetchLinksByUser(userId: userId)
      
        // Trier les liens par date de création (du plus récent au plus ancien)
            self.userLinks = response.sorted { $0.createdAt > $1.createdAt }
        
    }
    
}

