//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Maria Habib on 30/10/2021.
//

import UIKit
import WebKit

class NewsDetailViewController: UINavigationController  {
    
    var selectedNewsArticle: Article?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.webView.stopLoading()
    }

    private func configureUI() {
        self.view.backgroundColor = .white
        
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.view = self.webView
        
        self.webView.allowsBackForwardNavigationGestures = true
        
        if let article = self.selectedNewsArticle {
            guard let url = URL(string: article.url) else {
                return
            }
            
            let urlRequest: URLRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }
}

extension NewsDetailViewController: WKNavigationDelegate {
    
}
