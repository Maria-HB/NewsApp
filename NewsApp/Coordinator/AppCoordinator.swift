//
//  AppCoordinator.swift
//  NewsApp
//
//  Created by Maria Habib on 30/10/2021.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
    func newsArticleSelected(article: Article)
}


class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        //create news list view controller
        let newsListViewController = NewsListViewController()
        //set coordinator var in news list view controller
        newsListViewController.coordinator = self
        //initialize news list view model
        newsListViewController.viewModel = NewsListViewModel(dataManager: NewsDataManager(remoteDataManager: RemoteNewsDataManager()), delegate: newsListViewController)
        //add it to navigation controller
        self.navigationController.viewControllers = [newsListViewController]
    }
    
    func newsArticleSelected(article: Article) {
        let newsDetailViewController = NewsDetailViewController()
        newsDetailViewController.selectedNewsArticle = article
        navigationController.show(newsDetailViewController, sender: nil)
    }
}
