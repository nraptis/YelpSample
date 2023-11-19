//
//  RatingResponse.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import Foundation

struct ReviewsResponse: Decodable {
    let reviews: [Review]
}
