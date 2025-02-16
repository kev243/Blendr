//
//  ChooseLinkCell.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import SwiftUI
import Kingfisher

struct ChooseLinkCell: View {
    var media:Media
    var body: some View {
        VStack{
            KFImage(URL(string:media.imageUrl ))
               .resizable()
               .scaledToFill()
               .frame(width: 70, height: 70)
            
            Text(media.name)
                .font(.title3)
                .scaledToFit()
                .minimumScaleFactor(0.6)
        }
    }
}

//#Preview {
//    ChooseLinkCell(media: Media(id: UUID, name: "Instagram", type: "Media Social", imageUrl: "https://res.cloudinary.com/dhwfhmngb/image/upload/v1714623404/instagram_ow3vqc.png", url: "https://www.instagram.com/"))
//}
