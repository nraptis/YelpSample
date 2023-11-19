//
//  BusinessTableViewCell.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbContainerView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbContainerView.backgroundColor = .clear
        
        containerView.backgroundColor = UIColor(red: 0.9125,
                                                green: 0.9125,
                                                blue: 0.9125,
                                                alpha: 1.0)
        containerView.layer.cornerRadius = 12.0
        containerView.layer.borderColor = UIColor(red: 0.8125,
                                                  green: 0.8125,
                                                  blue: 0.8125,
                                                  alpha: 1.0).cgColor
        containerView.layer.borderWidth = 1.0
        
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOffset = CGSize(width: -1.0,
                                                  height: 2.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func inject(business: Business,
                viewModel: BusinessListViewModel) {
        nameLabel.text = viewModel.businessName(for: business)
        ratingLabel.text = viewModel.businessRating(for: business)
        priceLabel.text = viewModel.businessPrice(for: business)
        distanceLabel.text = viewModel.businessDistance(for: business)
        
        if let image = viewModel.businessImage(business: business) {
            thumbImageView.image = image
        } else {
            thumbImageView.image = nil
        }
    }
    
}
