//
//  NewsDataManager.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

protocol NewsDataManagerProtocol {
    func loadNews(completion: @escaping(Result<[Article], Error>) -> Void)
}

struct NewsDataManager: NewsDataManagerProtocol {
    var remoteDataManager: NewsDataManagerProtocol!
    
    func loadNews(completion: @escaping(Result<[Article], Error>) -> Void) {
        remoteDataManager.loadNews(completion: completion)
    }
}
