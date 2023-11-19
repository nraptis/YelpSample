//
//  BusinessDetailsViewModel.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit
import Combine

class BusinessDetailsViewModel {
    
    let businessListViewModel: BusinessListViewModel
    let business: Business
    let reviews: [Review]
    let recentCellUpdatePublisher = PassthroughSubject<Int, Never>()
    
    private lazy var userImageDownloader: ImageDownloader = {
        let result = ImageDownloader()
        result.delegate = self
        return result
    }()
    
    init(businessListViewModel: BusinessListViewModel,
        business: Business, reviews: [Review]) {
        self.businessListViewModel = businessListViewModel
        self.business = business
        self.reviews = reviews
        
        for review in self.reviews {
            var url: URL?
            if let urlSting = review.user?.image_url {
                url = URL(string: urlSting)
            }
            userImageDownloader.addDownloadTask(for: review, url: url)
        }
    }
        
    func review(at index: Int) -> Review? {
        if index >= 0 && index < reviews.count {
            return reviews[index]
        }
        return nil
    }
    
    func reviewIndex(review: Review) -> Int? {
        for i in 0..<reviews.count {
            if reviews[i] == review {
                return i
            }
        }
        return nil
    }
    
    func reviewImage(review: Review) -> UIImage? {
        userImageDownloader.image(for: review)
    }
    
    func reviewImageDidFailToDownload(review: Review) -> Bool {
        userImageDownloader.imageDidFail(for: review)
    }
    
    
    func reviewUsername(for review: Review) -> String {
        return review.user?.name ?? "Unknown"
    }
    
    func reviewRating(for review: Review) -> String {
        if let rating = review.rating {
            return String(format: "Rating: %.1f", rating)
        }
        return "Rating: ?.?"
    }
    
    func reviewText(for review: Review) -> String {
        if let text = review.text {
            return text
        }
        return ""
    }
    
    func reviewDate(for review: Review) -> String {
        if let date = review.time_created {
            return "Date: \(date)"
        }
        return "Date: ???"
    }
    
    func businessName(for business: Business) -> String {
        business.name
    }
    
    func businessRating(for business: Business) -> String {
        if let rating = business.rating {
            return String(format: "Rating: %.1f", rating)
        }
        return "Rating: ?.?"
    }
    
    func businessPrice(for business: Business) -> String {
        if let price = business.price {
            return "Price: \(price)"
        }
        return "Price: ???"
    }
    
    func businessAddress(for business: Business) -> String {
        if let addressArray = business.location?.display_address {
            if let address = addressArray.first {
                return "Address: \(address)"
            }
        }
        return "Address: ???"
    }
    
    func businessPhone(for business: Business) -> String {
        if let phone = business.display_phone {
            return "Phone: \(phone)"
        }
        return "Phone: ???"
    }
    
    func businessDistance(for business: Business) -> String {
        if let distance = business.distance {
            return String(format: "Distance: %.2f mi", metersToMiles(meters: distance))
        }
        return "Distance: ?.?? mi"
    }
}

extension BusinessDetailsViewModel: ImageDownloaderDelegate {
    func imageDownloadDidStart(for hashable: AnyHashable) {
        reviewHashablePublish(hashable)
    }
    
    func imageDownloadDidComplete(for hashable: AnyHashable, image: UIImage) {
        reviewHashablePublish(hashable)
    }
    
    func imageDownloadDidFail(for hashable: AnyHashable) {
        reviewHashablePublish(hashable)
    }
    
    func imageDownloadDidCancel(for hashable: AnyHashable) {
        reviewHashablePublish(hashable)
    }
    
    private func reviewHashablePublish(_ hashable: AnyHashable) {
        if let review = hashable as? Review {
            if let index = reviewIndex(review: review) {
                recentCellUpdatePublisher.send(index)
            }
        }
    }
}
