//
//  UIImageViewExt.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/4/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

var downloadImageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageFromUrl(urlString: String) {
        if let imageFromCache = downloadImageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        Networking.shared().getDrinkImageForCategories(urlString: urlString) { image in
            DispatchQueue.main.async {
                if let imageToCache = image {
                    downloadImageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                }
            }
        }
    }
}
