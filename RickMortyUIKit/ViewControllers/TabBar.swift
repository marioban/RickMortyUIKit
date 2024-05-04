//
//  TabBar.swift
//  RickMortyUIKit
//
//  Created by Mario Ban on 31.01.2023..
//

import UIKit

class TabBar : UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    fileprivate func createNavBarController(for rootViewController: UIViewController,title: String,image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
    
    func setupVCs() {
        viewControllers = [
            createNavBarController(for: CharacterListVC(), title: NSLocalizedString("List", comment: ""), image: UIImage(systemName: "list.bullet")! ),
            createNavBarController(for: FavouritesVC(), title: NSLocalizedString("Favourites", comment: ""), image: UIImage(systemName: "heart.fill")!)]
    }
    
}
