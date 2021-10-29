//
//  NewsCellViewModel.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

struct NewsCellViewModel {
    var imageURL: URL?
    var titleText: String?
    var description: String?
    
    var placeHolderImageName: String = "image-not-available"

    init() {
        //Empty Initializer
    }
    
    init(news: Article) {
        imageURL = URL(string: news.urlToImage)
        titleText = news.title
        description = news.description
    }
}
