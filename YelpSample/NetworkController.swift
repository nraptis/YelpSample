//
//  NetworkController.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/25/23.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badParse
    case badResponse
    case missingData
    case wrapped(error: Error)
}

class NetworkController: NSObject, URLSessionDelegate {
    
    private let decoder = JSONDecoder()
    
    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 15.0
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer OyFRR5PRd5I5hJ1f1ihFkqyANxelEJi0L6T06z3OvrthiWSan7_0ZZSZ_IhganUVxsCMwcxA-qmCeJJGkcyN-zW5CMWm-IVlyc0JZx2Ya92MU6Smr9OTuHuoy2EzY3Yx", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchBusinesss(lat: Double, lng: Double, completion: @escaping (Result<[Business], NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?limit=20&categories=restaurants&latitude=\(lat)&longitude=\(lng)") else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.badURL))
            }
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: self,
                                    delegateQueue: OperationQueue.main)
        let request = makeRequest(url: url)
        session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(NetworkError.wrapped(error: error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.missingData))
                return
            }
            
            guard let businessObject = try? self.decoder.decode(BusinessResponse.self, from: data) else {
                completion(.failure(NetworkError.badParse))
                return
            }
            completion(.success(businessObject.businesses))
        }
        .resume()
    }
    
    func fetchReviews(business: Business, completion: @escaping (Result<[Review], NetworkError>) -> Void) {
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/\(business.id)/reviews") else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.badURL))
            }
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: self,
                                    delegateQueue: OperationQueue.main)
        let request = makeRequest(url: url)
        session.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(NetworkError.wrapped(error: error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.missingData))
                return
            }
            guard let reviewsObject = try? self.decoder.decode(ReviewsResponse.self, from: data) else {
                completion(.failure(NetworkError.badParse))
                return
            }
            completion(.success(reviewsObject.reviews))
        }
        .resume()
    }
    
}
