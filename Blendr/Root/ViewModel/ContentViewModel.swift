//
//  ContentViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import Foundation
import Supabase
import Combine

@MainActor
class ContentViewModel:ObservableObject {
    
  
    @Published var userSession: Supabase.User?
    
    
       private var cancellables = Set<AnyCancellable>()
       
       init() {
           setupSubscribers()
       }
       
   @MainActor
   private func setupSubscribers() {
       AuthService.shared.$userSession
                  .sink { [weak self] userSession in
                      self?.userSession = userSession
                  }
                  .store(in: &cancellables)
          }
}
