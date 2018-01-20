//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by John Martin on 1/8/18.
//  Copyright © 2018 John Martin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    private var imageUrlString: String?
    func loadImage(urlString: String) {
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            self.image = imageFromCache as? UIImage
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else { print(error.debugDescription); return}
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject )
            }
        }).resume()
    }
}
