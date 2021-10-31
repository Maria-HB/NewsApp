//
//  NewsDataManager.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

protocol NewsDataManagerProtocol {
    func loadNewsFor(pageNo: Int, completion: @escaping(Result<APIResponse, Error>) -> Void)
}

struct NewsDataManager: NewsDataManagerProtocol {
    var remoteDataManager: NewsDataManagerProtocol!
    
    func loadNewsFor(pageNo: Int, completion: @escaping(Result<APIResponse, Error>) -> Void) {
        remoteDataManager.loadNewsFor(pageNo: pageNo, completion: completion)
    }
}
