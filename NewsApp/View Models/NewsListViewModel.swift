//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

protocol NewsListViewModelProtocol {
    var screenTitle: String { get }
    var noResultMessage: String { get }
    var dataManager: NewsDataManagerProtocol { get set }
    var delegate: NewsListViewModelDelegate? { get set }
    func load()
    func numberOfNewsItems() -> Int
    func cellViewModel(for index: Int) -> NewsCellViewModel
}

protocol NewsListViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailLoading(message: String)
}

class NewsListViewModel: NewsListViewModelProtocol {
    var screenTitle: String = "News-Screen-Title".localizedString()
    var noResultMessage: String = "No-News-Available".localizedString()
    var dataManager: NewsDataManagerProtocol
    weak var delegate: NewsListViewModelDelegate?
    
    var newsArray: [Article] = [Article]()
    
    init(dataManager: NewsDataManagerProtocol, delegate: NewsListViewModelDelegate?) {
        self.dataManager = dataManager
        self.delegate = delegate
    }
    
    func load() {
        self.delegate?.didStartLoading()
        dataManager.loadNews { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let apiResponse):
                self.newsArray = apiResponse.articles
                self.delegate?.didFinishLoading()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.delegate?.didFailLoading(message: "Generic-Error-Message".localizedString())
            }
        }
    }
    
    func numberOfNewsItems() -> Int {
        return self.newsArray.count
    }
    
    func cellViewModel(for index: Int) -> NewsCellViewModel {
        guard index < self.newsArray.count else {
            print("Index path is greater than news items")
            return NewsCellViewModel()
        }
        
        return NewsCellViewModel(news: self.newsArray[index])
    }
    
}