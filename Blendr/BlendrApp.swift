//
//  BlendrApp.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI
import GoogleSignIn

@main
struct BlendrApp: App {
    @StateObject var viewModel = RegistrationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onOpenURL{ url in
//                    GIDSignIn.sharedInstance.handle(url)
//                }
        }
    }
}
