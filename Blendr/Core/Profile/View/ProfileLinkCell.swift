//
//  ProfileLinkCell.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-15.
//

import SwiftUI
import Kingfisher


struct ProfilLinkCell: View {
    var link:Link
    var body: some View {
        VStack {
            KFImage(URL(string: link.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
            
            Text(link.name)
                .font(.title3)
                .scaledToFit()
                .minimumScaleFactor(0.6)
        }
        
    }
}

//#Preview {
//    ProfileLinkCell()
//}
