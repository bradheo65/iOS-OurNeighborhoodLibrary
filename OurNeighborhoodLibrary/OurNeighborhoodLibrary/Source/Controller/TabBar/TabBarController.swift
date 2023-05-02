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
    
    enum Setup {
        static let booksImageName: String = "books.vertical.circle"
        static let booksTitle: String = "Books"
        static let searchBooksImageName: String = "magnifyingglass"
        static let searchBooksTitle: String = "Search"
    }
    
    func setupTabBar() {
        self.tabBar.backgroundColor = .secondarySystemBackground
    }
    
    func setupTabBarItem() {
        let booksViewController = UINavigationController(
            rootViewController: BooksViewController()
        )
        booksViewController.tabBarItem.image = UIImage(
            systemName: Setup.booksImageName
        )
        booksViewController.title = Setup.booksTitle
        
        let searchBooksViewController = UINavigationController(
            rootViewController: SearchBooksViewController()
        )
        searchBooksViewController.tabBarItem.image = UIImage(
            systemName: Setup.searchBooksImageName
        )
        searchBooksViewController.title = Setup.searchBooksTitle
        
        viewControllers = [
            booksViewController, searchBooksViewController
        ]
    }
    
}
