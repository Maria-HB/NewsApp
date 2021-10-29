//
//  UIImageView+Extension.swift
//  NewsApp
//
//  Created by Maria Habib on 29/10/2021.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWith(url: URL) {
        
        //reset the image
        self.image = UIImage(named: "image-not-available")
        self.contentMode = .scaleAspectFit
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
            self.contentMode = .scaleAspectFill
            return
        }
        
        //otherwise, download the image from firebase
        NetworkManager.urlRequest(url: url) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    //self.thumbnailImageView.image = UIImage(data: data)
                    self.image = UIImage(data: data)
                    self.contentMode = .scaleAspectFill
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                    }
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
}
