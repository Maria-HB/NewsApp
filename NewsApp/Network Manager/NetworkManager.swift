//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

class NetworkManager {
    class func urlRequest(url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 120)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, _, error in
            //request failed - error returned
            if let error = error {
                completion(.failure(error))
            } else {
                if let data = data {
                    //request successfully returned with data, send the data back
                    completion(.success(data))
                } else {
                    //request returned with no data
                    completion(.failure(CustomError.noData))
                }
            }
        }
        
        task.resume()
    }
}
