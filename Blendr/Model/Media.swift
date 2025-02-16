//
//  Media.swift
//  Blendr
//
//  Created by Kevin Nimi on 2024-06-12.
//

import Foundation
struct Media: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let type: String
    let imageUrl: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case imageUrl = "image_url"
        case url
    }
}
