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
    var isPaginating: Bool { get }
    func load()
    func resetPageNoAndTotalNoOfPages()
    func numberOfNewsItems() -> Int
    func cellViewModel(for index: Int) -> NewsCellViewModel
    func cellSelected(index: Int)
}

protocol NewsListViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didFailLoading(message: String)
    func noMorePagesToFetchRemoveSpinnerView()
    func displayDetails(newsArticle: Article)
}

class NewsListViewModel: NewsListViewModelProtocol {
    var screenTitle: String = "News-Screen-Title".localizedString()
    var noResultMessage: String = "No-News-Available".localizedString()
    var dataManager: NewsDataManagerProtocol
    weak var delegate: NewsListViewModelDelegate?
    
    var newsArray: [Article] = [Article]()
    var totalNoOfPages: Int = 1
    var currentPage: Int = 1
    var isPaginating = false
    
    init(dataManager: NewsDataManagerProtocol, delegate: NewsListViewModelDelegate?) {
        self.dataManager = dataManager
        self.delegate = delegate
    }
    
    func resetPageNoAndTotalNoOfPages() {
        self.currentPage = 1
        self.totalNoOfPages = 1
        //remove all news articles from news array
        self.newsArray.removeAll()
    }
    
    func updateCurrentPageNo() {
        self.currentPage += 1
    }
    
    func calculateTotalNoOfPages(for totalResults:Int) -> Int {
        let quotient = totalResults / defaultPageSize
        let remainder =  totalResults % defaultPageSize
        if remainder != 0 {
            self.totalNoOfPages = quotient + 1
        } else {
            self.totalNoOfPages = quotient
        }
        
        return self.totalNoOfPages
    }
    
    func load() {
        guard self.currentPage <= self.totalNoOfPages else {
            self.delegate?.noMorePagesToFetchRemoveSpinnerView()
            return
        }
        self.isPaginating = true
        self.delegate?.didStartLoading()
        dataManager.loadNewsFor(pageNo: currentPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let apiResponse):
                self.newsArray.append(contentsOf: apiResponse.articles)
                //calculate total no of pages returned
                print(apiResponse.totalResults)
                let _ = self.calculateTotalNoOfPages(for: apiResponse.totalResults)
                self.delegate?.didFinishLoading()
                self.isPaginating = false
                self.updateCurrentPageNo()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.isPaginating = false
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
    
    func cellSelected(index: Int) {
        guard index < self.newsArray.count else {
            print("Indexpath greater that gift card count")
            return
        }
        
        self.delegate?.displayDetails(newsArticle: self.newsArray[index])
    }
    
}
