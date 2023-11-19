//
//  BusinessListViewController.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/25/23.
//

import UIKit
import Combine

class BusinessListViewController: UIViewController {
    
    private static let businessCellIdentifier = "business_cell"

    lazy var tableView: UITableView = {
        let result = UITableView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.dataSource = self
        result.delegate = self
        result.register(UINib(nibName: "BusinessTableViewCell", bundle: nil),
                        forCellReuseIdentifier: Self.businessCellIdentifier)
        return result
    }()
    
    lazy var loadingView: LoadingView = {
        let result = LoadingView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    let viewModel: BusinessListViewModel
    
    private var subscribers = Set<AnyCancellable>()
    
    required init(viewModel: BusinessListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewController = self

        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        viewModel.$businesses
            .receive(on: OperationQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        viewModel.recentCellUpdatePublisher
            .receive(on: OperationQueue.main)
            .sink { [weak self] index in
                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
            .store(in: &subscribers)
        
        
        viewModel.loadingStateUpdatePublisher
            .receive(on: OperationQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.viewModel.isLoadingReviews || self.viewModel.isLoadingRestaurants {
                    self.loadingView.show()
                } else {
                    self.loadingView.hide()
                }
            }
            .store(in: &subscribers)
        
        self.title = "Restaurant Finder"
    }
}

extension BusinessListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.businessCellIdentifier) as? BusinessTableViewCell else {
            fatalError("Unable to obtain business table view cell...")
        }
        
        guard let business = viewModel.business(at: indexPath.row) else {
            return UITableViewCell(style: .default,
                                   reuseIdentifier: nil)
        }
        
        cell.inject(business: business,
                    viewModel: viewModel)
        
        return cell
    }
}

extension BusinessListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let business = viewModel.business(at: indexPath.row) {
            viewModel.notifyBusinessCellVisible(business: business)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let business = viewModel.business(at: indexPath.row) {
            viewModel.notifyBusinessCellInvisible(business: business)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let business = viewModel.business(at: indexPath.row) {
            viewModel.handleDidSelectBusiness(for: business)
        }
    }
}
