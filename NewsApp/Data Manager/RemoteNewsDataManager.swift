//
//  RemoteNewsDataManager.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

struct RemoteNewsDataManager: NewsDataManagerProtocol {
    //func to load news
    func loadNews(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = APIPath.topHeadlinesURL else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        NetworkManager.urlRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
