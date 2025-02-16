//
//  User.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-06.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    var id: UUID?
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var isPrivate: Bool?
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullname = "fullname"
        case email = "email"
        case username = "username"
        case profileImageUrl = "profile_image_url"
        case bio = "bio"
        case isPrivate = "is_private"
        case createdAt = "created_at"
    }
}


extension User {
    static var MOCK_USER = User( fullname: "name", email: "user@gmail.com", username: "username",profileImageUrl: "https://res.cloudinary.com/dhwfhmngb/image/upload/v1719250960/user_aeefnl.jpg",bio: "Ma bio est un exemple pour tous ",isPrivate: false, createdAt: .now )
}
