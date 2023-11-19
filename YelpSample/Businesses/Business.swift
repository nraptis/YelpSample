//
//  Business.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/25/23.
//

import Foundation

struct Business: Decodable {
    
    let id: String
    let name: String
    let image_url: String?
    let review_count: Int?
    let is_closed: Bool?
    let rating: Double?
    let coordinates: Coordinate?
    let location: Location?
    let phone: String?
    let display_phone: String?
    let distance: Double?
    let price: String?
    
    struct Coordinate: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    struct Location: Decodable {
        let address1: String?
        let address2: String?
        let address3: String?
        let city: String?
        let zip_code: String?
        let state: String?
        let display_address: [String]?
    }
}

extension Business: Hashable {
    
    static func == (lhs: Business, rhs: Business) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
