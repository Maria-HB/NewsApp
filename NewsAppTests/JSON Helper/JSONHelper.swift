//
//  JSONHelper.swift
//  NewsAppTests
//
//  Created by Maria Habib on 30/10/2021.
//

import Foundation

class JSONHelper {
    func loadJSONDataFrom(fileName: String) -> Data {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            fatalError("Unable to find file path for \(fileName).json")
        }

        guard let jsonString = try? NSString(contentsOfFile: pathString, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to \(fileName).json to string")
        }

        guard let jsonData = jsonString.data(using: String.Encoding.utf8.rawValue) else {
            fatalError("Unable to convert json string to Data")
        }

        return jsonData
    }

    func jsonStringFrom(data: Data) -> String? {
        return String(data: data, encoding: String.Encoding.utf8)
    }

    func dictionaryFrom(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }

        return nil
    }
}
