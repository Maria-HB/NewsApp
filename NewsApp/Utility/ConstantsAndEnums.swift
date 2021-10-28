//
//  ConstantsAndEnums.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation
import UIKit

let contentSpacing: CGFloat = 16

struct Constants {
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?q=Apple&from=2021-10-28&sortBy=popularity&apiKey=191e210456a84b36b96e18e8f129ba99")
}

enum CustomError: Error {
    case invalidURL
    case noData
}
