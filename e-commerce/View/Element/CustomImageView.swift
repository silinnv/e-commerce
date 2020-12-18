//
//  CustomImageView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/14/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    static var imageCashe   = NSCache<NSString, UIImage>()
    private var task:       URLSessionTask!
    
    func loadImage(url: URL, complition: (() -> Void)? = nil) {
        
        func setImage(newImage: UIImage) {
            DispatchQueue.main.async {
                self.image = newImage
                if let complition = complition { complition() }
            }
        }
        
        if let prevTask = task {
            prevTask.cancel()
        }
        
        let imageKey = url.absoluteString as NSString
        
        if let cachedImage = CustomImageView.imageCashe.object(forKey: imageKey) {
            setImage(newImage: cachedImage)
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                let imageData = data,
                let loadedImage = UIImage(data: imageData) else { return }
            
            CustomImageView.imageCashe.setObject(loadedImage, forKey: imageKey)
            setImage(newImage: loadedImage)
        }
        task.resume()
    }
}
