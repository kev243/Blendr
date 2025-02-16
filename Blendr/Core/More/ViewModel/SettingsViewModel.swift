//
//  SettingsViewModel.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-18.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI



class SettingsViewModel: ObservableObject {
    @Published var currentUser:User?
    @State var linkUser:String = "blendr-app.vercel.app"
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isPrivateToggleOn: Bool = false {
        didSet {
            Task {
                try  await updateUserPrivacy()
                
            }
        }
    }
    
    init(){
        setupSubscribers()
    }
    
    private func setupSubscribers(){
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
            self?.isPrivateToggleOn = user?.isPrivate ?? false
        }.store(in:&cancellables)
    }
    
    @MainActor
    func updateUserPrivacy() async throws {
        try await UserService.shared.updateUserPrivacy(status: isPrivateToggleOn)
    }
}
