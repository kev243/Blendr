//
//  ChooseLinkView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import SwiftUI
import PopupView

struct ChooseLinkView: View {
    @StateObject var viewModel = ChooseViewModel()
    let columns:[GridItem]=[GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible()),]
    @State private var showAlert = false
    @State private var selectedMedia: Media? = nil
    @State private var test = false
    

    
    var body: some View {
        NavigationStack {
            
            //MARK:  Search bar
            TextField("Rechercher...", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.filteredMedia){ media in
                        ChooseLinkCell(media: media)
                            .onTapGesture {
                                selectedMedia = media
                            }
                    }
                 
                }
                
            }
            .navigationTitle("Choissisez un lien")
            .navigationBarTitleDisplayMode(.inline)
            .scrollIndicators(.hidden)
            .sheet(item: $selectedMedia) { media in // Afficher la feuille modale lorsque selectedLogo est non nil
                NavigationStack {
                    FormAddLinkView(media: media)
                        .navigationTitle("Ajouter un lien")
                        .navigationBarTitleDisplayMode(.inline)
                }
                .presentationDetents([.medium])
            
                
            }
            .onAppear {
                Task {
                    try await viewModel.fetchAllMedia()
                }
            }
            
        }

    }
        
    
}





#Preview {
    NavigationStack{
        ChooseLinkView()
    }
}
