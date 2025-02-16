//
//  CircularProfileImageView.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    var width: CGFloat = 120
    var height: CGFloat = 120
    let user: User?
    var body: some View {
        if let imageUrl = user?.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    CircularProfileImageView(user: User.MOCK_USER)
}
