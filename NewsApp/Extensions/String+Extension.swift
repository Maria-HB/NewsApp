//
//  String+Extension.swift
//  NewsApp
//
//  Created by Maria Habib on 28/10/2021.
//

import Foundation

extension String {
    func localizedString() -> String {
        return NSLocalizedString(self, tableName: "Assignment", comment: "")
    }
}
