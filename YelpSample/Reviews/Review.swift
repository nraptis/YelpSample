//
//  Rating.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import Foundation

struct Review: Decodable {
    
    let id: String
    let text: String?
    let rating: Int?
    let time_created: String?
    let user: User?
    
    struct User: Decodable {
        let id: String
        let name: String?
        let image_url: String?
    }
}

extension Review: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Review, rhs: Review) -> Bool {
        lhs.id == rhs.id
    }
}
