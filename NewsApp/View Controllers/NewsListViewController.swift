//
//  ViewController.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import UIKit

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
        self.newsTableView.allowsSelection = false
        self.newsTableView.dataSource = self
        self.newsTableView.delegate = self
    }
    
    private func configureNoResultLabel() {
        self.noResultLabel.text = self.viewModel.noResultMessage
        self.noResultLabel.isHidden = true
        
        self.noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.noResultLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: contentSpacing).isActive = true
        self.noResultLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: contentSpacing).isActive = true
        self.noResultLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

//MARK: - NewsListViewModelDelegate
extension NewsListViewController: NewsListViewModelDelegate {
    func didStartLoading() {
         //show activity indicator
        self.startActivityIndicator()
    }
    
    func didFinishLoading() {
        DispatchQueue.main.async {
            //hide activity indicator
            self.stopActivityIndicator()
            self.noResultLabel.isHidden = self.viewModel.numberOfNewsItems() != 0
            self.newsTableView.isHidden = self.viewModel.numberOfNewsItems() == 0
            self.newsTableView.reloadData()
        }
    }
    
    func didFailLoading(message: String) {
        //hide activity indicator
        self.stopActivityIndicator()
        //show alert with error message
        self.showAlert(message: message, title: nil)
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = indexPath.row % 2 == 0 ? .tertiarySystemGroupedBackground : .white
    }
}



