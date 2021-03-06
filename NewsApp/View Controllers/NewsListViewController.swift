//
//  ViewController.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import UIKit
import SafariServices

class NewsListViewController: UIViewController {
    
    //private variables and constants
    private var newsTableView: UITableView = {
        let newsTableView = UITableView()
        newsTableView.rowHeight = UITableView.automaticDimension
        return newsTableView
    }()
    
    private var noResultLabel: UILabel = {
        let noResultsLabel = UILabel()
        noResultsLabel.numberOfLines = 0
        noResultsLabel.textAlignment = .center
        noResultsLabel.font = UIFont.systemFont(ofSize: 16)
        noResultsLabel.isHidden = true
        return noResultsLabel
    }()
    
    var viewModel: NewsListViewModelProtocol!
    var coordinator: Coordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.viewModel != nil, "View Model not set.")
        
        // Do any additional setup after loading the view.
        self.configureView()
        self.viewModel.load()
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
        self.title = self.viewModel.screenTitle
        
        self.view.addSubview(self.noResultLabel)
        self.view.addSubview(self.newsTableView)
    
        self.configureTableView()
        self.configureNoResultLabel()
    }
    
    private func configureTableView() {
        self.newsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.newsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.newsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.newsTableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        self.newsTableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        self.newsTableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.newsTableView.separatorStyle = .none
        self.newsTableView.allowsSelection = true
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
        
        //add pull to refresh control
        self.newsTableView.refreshControl = UIRefreshControl()
        self.newsTableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    private func configureNoResultLabel() {
        self.noResultLabel.text = self.viewModel.noResultMessage
        self.noResultLabel.isHidden = true
        
        self.noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.noResultLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: contentSpacing).isActive = true
        self.noResultLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: contentSpacing).isActive = true
        self.noResultLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @objc func callPullToRefresh() {
        //reload the virew model
        self.viewModel.resetPageNoAndTotalNoOfPages()
        self.viewModel.load()
    }
}

//MARK: - NewsListViewModelDelegate
extension NewsListViewController: NewsListViewModelDelegate {
    
    func didStartLoading() {
         //show activity indicator in case pull to refresh is not being called
        if self.newsTableView.refreshControl?.isRefreshing != true {
            self.startActivityIndicator()
        }
    }
    
    func didFinishLoading() {
        DispatchQueue.main.async {
            //hide activity indicator
            if self.newsTableView.refreshControl?.isRefreshing != true {
                self.stopActivityIndicator()
            } else {
                self.newsTableView.refreshControl?.endRefreshing()
            }
            
            //hide table view footer
            self.newsTableView.tableFooterView = nil
            
            self.noResultLabel.isHidden = self.viewModel.numberOfNewsItems() != 0
            self.newsTableView.isHidden = self.viewModel.numberOfNewsItems() == 0
            self.newsTableView.reloadData()
        }
    }
    
    func didFailLoading(message: String) {
        DispatchQueue.main.async {
            //hide activity indicator
            if self.newsTableView.refreshControl?.isRefreshing != true {
                self.stopActivityIndicator()
            } else {
                self.newsTableView.refreshControl?.endRefreshing()
            }
            
            //hide table view footer
            self.newsTableView.tableFooterView = nil
            
            //show alert with error message
            self.showAlert(message: message, title: nil)
        }
    }
    
    func noMorePagesToFetchRemoveSpinnerView() {
        DispatchQueue.main.async {
            self.newsTableView.tableFooterView = nil
        }
    }
    
    func displayDetails(newsArticle: Article) {
        coordinator.newsArticleSelected(article: newsArticle)
    }
}

//MARK: - UITableViewDataSource
extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfNewsItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = self.viewModel.cellViewModel(for: indexPath.row)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.cellSelected(index: indexPath.row)
    }
}

//MARK: - UIScrollViewDelegate
extension NewsListViewController: UIScrollViewDelegate {
    
    private func createSpinnerView() -> UIView {
        let footerView = UIView(frame:CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (self.newsTableView.contentSize.height - scrollView.frame.size.height - 50) {
            //fetch more data - if already fetching return
            guard !viewModel.isPaginating else { return }
            //add footer view to table view
            self.newsTableView.tableFooterView = self.createSpinnerView()
            self.viewModel.load()

        }
    }
}


