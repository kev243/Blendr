//
//  ContentView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @StateObject var vm = ContentViewModel()
    var body: some View {
        Group{
            if vm.userSession != nil   {
               TabBarView()
            } else{
                WelcomeView()
                    .environmentObject(viewModel)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
