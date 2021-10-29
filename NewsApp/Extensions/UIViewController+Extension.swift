//
//  UIViewController+Extension.swift
//  NewsApp
//
//  Created by Maria Habib on 29/10/2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    var activityIndicatorTag: Int { return 999999 }
    
    //MARK: - Global Alert
    func showAlert(message: String, title: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Global Activity Indicator
    func startActivityIndicator() {
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.tag = self.activityIndicatorTag
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
        }
    }
    
    func stopActivityIndicator() {
        self.view.isUserInteractionEnabled = true
        DispatchQueue.main.async {
            if let activityIndicator = self.view.subviews.filter({$0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
