//
//  TabBarController.swift
//  OurNeighborhoodLibrary
//
//  Created by brad on 2023/04/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
        setupTabBarItem()
    }
    
}

private extension TabBarController {
    
    func setupTabBar() {
        self.tabBar.backgroundColor = .secondarySystemBackground
    }
    
    func setupTabBarItem() {
        let booksViewController = UINavigationController(
            rootViewController: BooksViewController()
        )
        booksViewController.tabBarItem.image = UIImage(
            systemName: "books.vertical.circle"
        )
        booksViewController.title = "Books"
        
        let searchBooksViewController = UINavigationController(
            rootViewController: SearchBooksViewController()
        )
        searchBooksViewController.tabBarItem.image = UIImage(
            systemName: "magnifyingglass"
        )
        searchBooksViewController.title = "Search"
        
        viewControllers = [
            booksViewController, searchBooksViewController
        ]
    }
    
}
