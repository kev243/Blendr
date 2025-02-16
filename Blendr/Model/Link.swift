//
//  Link.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import Foundation


struct Link: Identifiable, Codable, Equatable {
    var id: UUID // id du lien
    let name: String // nom du lien
    let imageUrl: String // image du lien
    let url: String // url du réseau
    let username: String // username du profil
    let userId: String // id de l'utilisateur qui l'a créé
    let type: String // type de lien
    let status: Bool // si le lien est visible ou pas
    let createdAt: Date // le jour et l'heure de la création du lien

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case url
        case username
        case userId = "user_id"
        case type
        case status
        case createdAt = "created_at"
    }
}


// Extension pour ajouter un Mock
extension Link {
    static let MOCK_LINK = Link(
        id: UUID(),
        name: "Example Link",
        imageUrl: "https://example.com/image.png",
        url: "https://example.com",
        username: "example_user",
        userId: UUID().uuidString,
        type: "Social Media",
        status: true,
        createdAt: Date()
    )
}
