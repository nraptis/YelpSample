//
//  SceneDelegate.swift
//  YelpSample
//
//  Created by Nicky Taylor on 1/25/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        
        let network = NetworkController()
        let businessListViewModel = BusinessListViewModel(network: network)
        let businessListViewController = BusinessListViewController(viewModel: businessListViewModel)
        let navigationController = UINavigationController(rootViewController: businessListViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

