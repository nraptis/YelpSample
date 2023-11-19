//
//  BusinessDetailsViewController.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit
import Combine

class BusinessDetailsViewController: UIViewController {
    
    let viewModel: BusinessDetailsViewModel
    
    private var subscribers = Set<AnyCancellable>()
    
    private var reviewCellViews = [ReviewCellView]()
    
    lazy var scrollView: UIScrollView = {
        let result = UIScrollView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    lazy var scrollContent: UIView = {
        let result = UIView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    lazy var restaurantImageView: UIImageView = {
        let result = UIImageView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.backgroundColor = UIColor.red.withAlphaComponent(0.8)
        result.contentMode = .scaleAspectFill
        result.clipsToBounds = true
        return result
    }()
    
    lazy var dataStackViewContainer: UIView = {
        let result = UIView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        
        result.backgroundColor = UIColor(red: 0.9125,
                                         green: 0.9125,
                                         blue: 0.9125,
                                         alpha: 1.0)
        result.layer.cornerRadius = 12.0
        result.layer.borderColor = UIColor(red: 0.8125,
                                           green: 0.8125,
                                           blue: 0.8125,
                                           alpha: 1.0).cgColor
        result.layer.borderWidth = 1.0
        result.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        result.layer.shadowRadius = 2.0
        result.layer.shadowOffset = CGSize(width: -1.0,
                                           height: 2.0)
        
        return result
    }()
    
    lazy var dataStackView: UIStackView = {
        let result = UIStackView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.axis = .vertical
        return result
    }()
    
    
    lazy var reviewStackViewContainer: UIView = {
        let result = UIView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.backgroundColor = UIColor(red: 0.9125,
                                         green: 0.9125,
                                         blue: 0.9125,
                                         alpha: 1.0)
        result.layer.cornerRadius = 12.0
        result.layer.borderColor = UIColor(red: 0.8125,
                                           green: 0.8125,
                                           blue: 0.8125,
                                           alpha: 1.0).cgColor
        result.layer.borderWidth = 1.0
        result.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        result.layer.shadowRadius = 2.0
        result.layer.shadowOffset = CGSize(width: -1.0,
                                           height: 2.0)
        
        return result
    }()
    
    lazy var reviewStackView: UIStackView = {
        let result = UIStackView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.axis = .vertical
        result.spacing = 12.0
        return result
    }()
    
    lazy var priceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 22.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var ratingLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 22.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var phoneLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 22.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.165, green: 0.165, blue: 0.165, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var distanceLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 22.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    lazy var addressLabel: UILabel = {
        let result = UILabel(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.font = UIFont.systemFont(ofSize: 22.0)
        result.textAlignment = .left
        result.textColor = UIColor(red: 0.125, green: 0.125, blue: 0.125, alpha: 1.0)
        result.numberOfLines = 0
        return result
    }()
    
    required init(viewModel: BusinessDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(scrollContent)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: scrollContent, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: scrollContent, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 1000),
            NSLayoutConstraint(item: scrollContent, attribute: .centerX, relatedBy: .equal, toItem: scrollView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: scrollContent, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0.0),
        ])
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: scrollContent, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 2200.0),
        ])
        
        scrollContent.addSubview(restaurantImageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: restaurantImageView, attribute: .left, relatedBy: .equal, toItem: scrollContent, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: restaurantImageView, attribute: .right, relatedBy: .equal, toItem: scrollContent, attribute: .right, multiplier: 1.0, constant: 0.0),
            restaurantImageView.topAnchor.constraint(equalTo: scrollContent.topAnchor)
        ])
        
        if let image = viewModel.businessListViewModel.businessImage(business: viewModel.business) {
            restaurantImageView.image = image
            
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: restaurantImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200.0),
            ])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: restaurantImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0.0),
            ])
        }
        
        scrollContent.addSubview(dataStackViewContainer)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: dataStackViewContainer, attribute: .left, relatedBy: .equal, toItem: scrollContent, attribute: .left, multiplier: 1.0, constant: 24.0),
            NSLayoutConstraint(item: dataStackViewContainer, attribute: .right, relatedBy: .equal, toItem: scrollContent, attribute: .right, multiplier: 1.0, constant: -24.0),
            NSLayoutConstraint(item: dataStackViewContainer, attribute: .top, relatedBy: .equal, toItem: restaurantImageView, attribute: .bottom, multiplier: 1.0, constant: 24.0),
            
        ])
        
        dataStackViewContainer.addSubview(dataStackView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: dataStackView, attribute: .left, relatedBy: .equal, toItem: dataStackViewContainer, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: dataStackView, attribute: .right, relatedBy: .equal, toItem: dataStackViewContainer, attribute: .right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: dataStackView, attribute: .top, relatedBy: .equal, toItem: dataStackViewContainer, attribute: .top, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: dataStackView, attribute: .bottom, relatedBy: .equal, toItem: dataStackViewContainer, attribute: .bottom, multiplier: 1.0, constant: -16.0),
        ])
        
        scrollContent.addSubview(reviewStackViewContainer)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: reviewStackViewContainer, attribute: .left, relatedBy: .equal, toItem: scrollContent, attribute: .left, multiplier: 1.0, constant: 24.0),
            NSLayoutConstraint(item: reviewStackViewContainer, attribute: .right, relatedBy: .equal, toItem: scrollContent, attribute: .right, multiplier: 1.0, constant: -24.0),
            NSLayoutConstraint(item: reviewStackViewContainer, attribute: .top, relatedBy: .equal, toItem: dataStackViewContainer, attribute: .bottom, multiplier: 1.0, constant: 24.0),
        ])
        
        reviewStackViewContainer.addSubview(reviewStackView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: reviewStackView, attribute: .left, relatedBy: .equal, toItem: reviewStackViewContainer, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: reviewStackView, attribute: .right, relatedBy: .equal, toItem: reviewStackViewContainer, attribute: .right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: reviewStackView, attribute: .top, relatedBy: .equal, toItem: reviewStackViewContainer, attribute: .top, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: reviewStackView, attribute: .bottom, relatedBy: .equal, toItem: reviewStackViewContainer, attribute: .bottom, multiplier: 1.0, constant: -16.0),
        ])
        
        for review in viewModel.reviews {
            let reviewCellView = ReviewCellView(viewModel: viewModel, review: review)
            reviewStackView.addArrangedSubview(reviewCellView)
            reviewCellViews.append(reviewCellView)
        }
        
        dataStackView.addArrangedSubview(addressLabel)
        dataStackView.addArrangedSubview(phoneLabel)
        dataStackView.addArrangedSubview(priceLabel)
        dataStackView.addArrangedSubview(ratingLabel)
        dataStackView.addArrangedSubview(distanceLabel)
        
        priceLabel.text = viewModel.businessPrice(for: viewModel.business)
        ratingLabel.text = viewModel.businessRating(for: viewModel.business)
        phoneLabel.text = viewModel.businessPhone(for: viewModel.business)
        distanceLabel.text = viewModel.businessDistance(for: viewModel.business)
        addressLabel.text = viewModel.businessAddress(for: viewModel.business)
        
        self.title = viewModel.business.name
        
        viewModel.recentCellUpdatePublisher
            .receive(on: OperationQueue.main)
            .sink { [weak self] index in
                self?.refreshUserAvatar(at: index)
            }
            .store(in: &subscribers)
    }
    
    private func refreshUserAvatar(at index: Int) {
        if index >= 0 && index < reviewCellViews.count {
            let reviewCellView = reviewCellViews[index]
            reviewCellView.refresh()
        }
        
    }
}
