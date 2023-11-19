//
//  RatingCellView.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit

class ReviewCellView: UIView {

    let viewModel: BusinessDetailsViewModel
    let review: Review
    required init(viewModel: BusinessDetailsViewModel, review: Review) {
        self.viewModel = viewModel
        self.review = review
        super.init(frame: .zero)
        
        styleSelf()
        layout()
        refresh()
        
        nameLabel.text = viewModel.reviewUsername(for: review)
        dateLabel.text = viewModel.reviewDate(for: review)
        ratingLabel.text = viewModel.reviewRating(for: review)
        reviewLabel.text = viewModel.reviewText(for: review)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        self.addSubview(topBox)
        
        NSLayoutConstraint.activate([
            topBox.topAnchor.constraint(equalTo: self.topAnchor),
            topBox.leftAnchor.constraint(equalTo: self.leftAnchor),
            topBox.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
        
        topBox.addSubview(userImageViewContainer)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: userImageViewContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 72.0),
            NSLayoutConstraint(item: userImageViewContainer, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 72.0),
            NSLayoutConstraint(item: userImageViewContainer, attribute: .left, relatedBy: .equal, toItem: topBox, attribute: .left, multiplier: 1.0, constant: 12.0),
            NSLayoutConstraint(item: userImageViewContainer, attribute: .top, relatedBy: .equal, toItem: topBox, attribute: .top, multiplier: 1.0, constant: 12.0),
            NSLayoutConstraint(item: userImageViewContainer, attribute: .bottom, relatedBy: .equal, toItem: topBox, attribute: .bottom, multiplier: 1.0, constant: -12.0),
        ])
        
        topBox.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: userImageViewContainer, attribute: .right, multiplier: 1.0, constant: 2.0),
            NSLayoutConstraint(item: nameLabel, attribute: .right, relatedBy: .equal, toItem: topBox, attribute: .right, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: topBox, attribute: .top, multiplier: 1.0, constant: 8.0)
        ])
        
        topBox.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: dateLabel, attribute: .left, relatedBy: .equal, toItem: userImageViewContainer, attribute: .right, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: topBox, attribute: .right, multiplier: 1.0, constant: -2.0),
            NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1.0, constant: 6.0),
        ])
        
        topBox.addSubview(ratingLabel)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: ratingLabel, attribute: .left, relatedBy: .equal, toItem: userImageViewContainer, attribute: .right, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: ratingLabel, attribute: .right, relatedBy: .equal, toItem: topBox, attribute: .right, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: ratingLabel, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1.0, constant: 6.0),
            
            NSLayoutConstraint(item: ratingLabel, attribute: .bottom, relatedBy: .equal, toItem: topBox, attribute: .bottom, multiplier: 1.0, constant: -2.0)
        ])
        
        userImageViewContainer.addSubview(userImageViewFailed)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: userImageViewFailed, attribute: .left, relatedBy: .equal, toItem: userImageViewContainer, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userImageViewFailed, attribute: .right, relatedBy: .equal, toItem: userImageViewContainer, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userImageViewFailed, attribute: .centerY, relatedBy: .equal, toItem: userImageViewContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userImageViewFailed, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 72.0),
            NSLayoutConstraint(item: userImageViewFailed, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 72.0)
        ])
        
        userImageViewContainer.addSubview(userImageView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: userImageView, attribute: .left, relatedBy: .equal, toItem: userImageViewContainer, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userImageView, attribute: .right, relatedBy: .equal, toItem: userImageViewContainer, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userImageView, attribute: .centerY, relatedBy: .equal, toItem: userImageViewContainer, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: userImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 72.0),
            NSLayoutConstraint(item: userImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 72.0)
        ])
        
        self.addSubview(reviewLabel)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: reviewLabel, attribute: .top, relatedBy: .equal, toItem: topBox, attribute: .bottom, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: reviewLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: reviewLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 8.0),
            NSLayoutConstraint(item: reviewLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -8.0)
        ])
    }
    
    func refresh() {
        var image: UIImage?
        if let userImage = viewModel.reviewImage(review: review) {
            image = userImage
        }
        
        if let image = image {
            userImageView.image = image
            userImageView.isHidden = false
            userImageViewFailed.isHidden = true
            
        } else if viewModel.reviewImageDidFailToDownload(review: review) {
            userImageView.isHidden = true
            userImageViewFailed.isHidden = false
        } else {
            userImageView.isHidden = true
            userImageViewFailed.isHidden = true
        }
    }
    
    lazy var topBox: UIView = {
        let result = UIView()
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    lazy var userImageViewContainer: UIImageView = {
        let result = UIImageView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        return result
    }()
    
    lazy var userImageViewFailed: UIImageView = {
        let result = UIImageView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.contentMode = .scaleAspectFit
        result.clipsToBounds = true
        result.tintColor = UIColor.gray
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 256, weight: .bold, scale: .large)
        if let image = UIImage(systemName: "x.square.fill", withConfiguration: symbolConfig) {
            result.image = image.withRenderingMode(.alwaysTemplate)
        }
        return result
    }()
    
    lazy var userImageView: UIImageView = {
        let result = UIImageView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.contentMode = .scaleAspectFit
        result.clipsToBounds = true
        result.layer.cornerRadius = 12.0
        return result
    }()
    
    lazy var nameLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var dateLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 16.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var ratingLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 16.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var reviewLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 14.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.085, green: 0.085, blue: 0.085, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    private func styleSelf() {
        backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.9125, alpha: 1.0)
        layer.cornerRadius = 12.0
        layer.borderColor = UIColor(red: 0.7825, green: 0.7825, blue: 0.8125, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: -1.0, height: 2.0)
    }
    
}
