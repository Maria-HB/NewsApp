//
//  RemoteNewsDataManager.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

struct RemoteNewsDataManager: NewsDataManagerProtocol {
    //func to load news
    func loadNewsFor(pageNo: Int, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        //update API Path to include page no
        let urlString = (APIPath.topHeadlinesURL?.absoluteString ?? "") + "&page=\(pageNo)"
        guard let url = URL(string: urlString) else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        
        NetworkManager.urlRequest(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result))//.articles))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
