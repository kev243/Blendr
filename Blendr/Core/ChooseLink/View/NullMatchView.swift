//
//  NullMatchView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-22.
//

import SwiftUI

struct NullMatchView: View {
    var body: some View {
        Text("Aucune correspondance")
            .font(.headline)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        
    }
}

#Preview {
    NullMatchView()
}
