//
//  YelpSampleTests.swift
//  YelpSampleTests
//
//  Created by Nicky Taylor on 1/26/23.
//

import XCTest
@testable import YelpSample

final class YelpSampleTests: XCTestCase {
    
    func testFetchBusinesses() {
        let expectation = XCTestExpectation(description: "businesses")
        let network = NetworkController()
        network.fetchBusinesss(lat: 33.7488, lng: -84.3877) { result in
            switch result {
                
            case .success(let results):
                guard results.count > 0 else {
                    XCTFail("No businesses, cannot pass.")
                    return
                }
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Failed fetch business...")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
