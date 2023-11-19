//
//  LoadingView.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/26/23.
//

import UIKit

class LoadingView: UIView {
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let result = UIActivityIndicatorView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.style = .large
        result.color = UIColor.white
        return result
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: activityIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: activityIndicatorView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        activityIndicatorView.startAnimating()
        isHidden = false
        isUserInteractionEnabled = true
    }
    
    func hide() {
        activityIndicatorView.stopAnimating()
        isHidden = true
        isUserInteractionEnabled = false
    }
}
