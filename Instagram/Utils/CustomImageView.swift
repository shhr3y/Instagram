//
//  CustomImageView.swift
//  Instagram
//
//  Created by Shrey Gupta on 16/08/20.
//  Copyright © 2020 Shrey Gupta. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastImageURLUsedToLoadImage: String?
    
    func loadImage(from urlString: String){
        
        //set image to nil
        self.image = nil
        
        //set lastImageURLUsedToLoadImage
        lastImageURLUsedToLoadImage = urlString
        
        //check if image exists in cache
        if let cachedImage = imageCache[urlString]{
            self.image = cachedImage
            return
        }
        //image does not exists in cache
        // url for image
        guard let url = URL(string: urlString) else { return }
        
        //fetch contents of url
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DEBUG: Error from loadImage: \(error.localizedDescription)")
                return
            }
            
            if self.lastImageURLUsedToLoadImage != url.absoluteString {
                return
            }
            
            //get image data
            guard let imageData = data else { return }
            
            //create image from imageData
            let image = UIImage(data: imageData)
            
            //set key and value for image cache
            imageCache[url.absoluteString] = image
            
            // set out retrieved image
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
