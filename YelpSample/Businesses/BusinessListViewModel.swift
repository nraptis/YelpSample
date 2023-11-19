//
//  BusinessListViewModel.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/25/23.
//

import UIKit
import Combine

func metersToMiles(meters: Double) -> Double {
    return meters * 0.000621371
}

class BusinessListViewModel {
    
    let recentCellUpdatePublisher = PassthroughSubject<Int, Never>()
    
    let loadingStateUpdatePublisher = PassthroughSubject<Void, Never>()
    var isLoadingRestaurants = false
    var isLoadingReviews = false
    
    @Published var businesses = [Business]()
    
    private lazy var businessImageDownloader: ImageDownloader = {
        let result = ImageDownloader()
        result.delegate = self
        return result
    }()
    
    private lazy var locationHelper: LocationHelper = {
        let result = LocationHelper()
        result.delegate = self
        return result
    }()
    
    
    
    
    weak var viewController: BusinessListViewController?
    
    let network: NetworkController
    init(network: NetworkController) {
        self.network = network
        
        isLoadingRestaurants = true
        locationHelper.fetch()
    }
    
    func business(at index: Int) -> Business? {
        if index >= 0 && index < businesses.count {
            return businesses[index]
        }
        return nil
    }
    
    func businessIndex(business: Business) -> Int? {
        for i in 0..<businesses.count {
            if businesses[i] == business {
                return i
            }
        }
        return nil
    }
    
    func businessImage(business: Business) -> UIImage? {
        businessImageDownloader.image(for: business)
    }
    
    func businessImageDidFailToDownload(business: Business) -> Bool {
        businessImageDownloader.imageDidFail(for: business)
    }
    
    //businessImageDownloader
    
    func notifyBusinessCellVisible(business: Business) {
        var url: URL?
        if let urlString = business.image_url {
            url = URL(string: urlString)
        }
        
        businessImageDownloader.addDownloadTask(for: business, url: url)
    }
    
    func notifyBusinessCellInvisible(business: Business) {
        
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
    
    func businessDistance(for business: Business) -> String {
        if let distance = business.distance {
            return String(format: "Distance: %.2f mi", metersToMiles(meters: distance))
        }
        return "Distance: ?.?? mi"
    }
    
    func fetchAquriums(lat: Double, lng: Double) {
        isLoadingRestaurants = true
        loadingStateUpdatePublisher.send(())
        network.fetchBusinesss(lat: lat, lng: lng) { result in
            switch result {
            case .success(let businesses):
                print("got businesses...")
                self.businesses = businesses
            case .failure(let error):
                print("businesses error: \(error.localizedDescription)")
            }
            
            self.isLoadingRestaurants = false
            self.loadingStateUpdatePublisher.send(())
        }
    }
    
    func handleDidSelectBusiness(for business: Business) {
        isLoadingReviews = true
        loadingStateUpdatePublisher.send(())
        network.fetchReviews(business: business) { result in
            
            switch result {
            case .success(let reviews):
                print("got reviews...")
                print("Reviews = \(reviews)")
                if let viewController = self.viewController {
                    let detailsViewModel = BusinessDetailsViewModel(businessListViewModel: self,
                                                                    business: business,
                                                                    reviews: reviews)
                    let detailsViewController = BusinessDetailsViewController(viewModel: detailsViewModel)
                    viewController.navigationController?.pushViewController(detailsViewController, animated: true)
                }
                
            case .failure(let error):
                print("Reviews error: \(error.localizedDescription)")
                if let viewController = self.viewController {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Couldn't Load", message: "We were unable to lod the reviews.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        viewController.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            self.isLoadingReviews = false
            self.loadingStateUpdatePublisher.send(())
        }
    }
    
}

extension BusinessListViewModel: ImageDownloaderDelegate {
    func imageDownloadDidStart(for hashable: AnyHashable) {
        //print("imageDownloadDidStart")
        businessHashablePublish(hashable)
    }
    
    func imageDownloadDidComplete(for hashable: AnyHashable, image: UIImage) {
        //print("imageDownloadDidComplete \(image.size.width) x \(image.size.height)")
        businessHashablePublish(hashable)
    }
    
    func imageDownloadDidFail(for hashable: AnyHashable) {
        //print("imageDownloadDidFail")
        businessHashablePublish(hashable)
    }
    
    func imageDownloadDidCancel(for hashable: AnyHashable) {
        //print("imageDownloadDidCancel")
        businessHashablePublish(hashable)
    }
    
    private func businessHashablePublish(_ hashable: AnyHashable) {
        if let business = hashable as? Business {
            if let index = businessIndex(business: business) {
                recentCellUpdatePublisher.send(index)
            }
        }
    }
    
    
}

extension BusinessListViewModel: LocationHelperDelegate {
    func locationDidFail() {
        print("got no location")
        self.fetchAquriums(lat: 33.7488, lng: -84.3877)
    }
    
    func locationDidUpdate(lat: Double, lng: Double) {
        print("got loc: \(lat), \(lng)")
        self.fetchAquriums(lat: lat, lng: lng)
    }
    
}
