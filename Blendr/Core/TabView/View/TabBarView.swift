//
//  TabView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-05.
//

import SwiftUI

struct TabBarView: View {
   @StateObject var viewModel = VmTab()
    @State private var selectedTab = 0
    

    var body: some View {
        TabView(selection: $selectedTab,
                content:  {
            
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "person.fill": "person")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    Text("Profile")
                }
                .onAppear{selectedTab = 0 }
                .tag(0)
            ChooseLinkView()
                .tabItem {
                    Image(systemName: "plus")
                    Text("Ajouter")
                }
                .onAppear{
                    selectedTab = 1
                }
                .tag(1)
       
                MoreView()
                .tabItem {
                    Image(systemName: "line.3.horizontal")
                    Text("Plus")
                }
                .onAppear{selectedTab = 2 }
                .tag(2)
            
        })
        .tint( Color("color2"))
    }
        
}

#Preview {
    TabBarView()
}
