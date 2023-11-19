//
//  BusinessResponse.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/25/23.
//

import Foundation

struct BusinessResponse: Decodable {
    let businesses: [Business]
}
