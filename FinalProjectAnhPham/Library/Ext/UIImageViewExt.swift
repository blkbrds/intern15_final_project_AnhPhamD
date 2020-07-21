//
//  UIImageViewExt.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/4/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit

//var downloadImageCache = NSCache<AnyObject, AnyObject>()
//
//extension UIImageView {
//    private static var urlKey = 0
//
//    private var currentURL: URL? {
//        get {
//            return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL
//        }
//        set {
//            objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    func loadImageFromUrl(urlString: String) {
//        if let imageFromCache = downloadImageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
//        self.currentURL = URL(string: urlString)
//        Networking.shared().getDrinkImageForCategories(urlString: urlString) { image in
//            DispatchQueue.main.async {
//                if let imageToCache = image {
//                    downloadImageCache.setObject(imageToCache, forKey: urlString as AnyObject)
//                    if self.currentURL?.absoluteString == urlString {
//                        self.image = imageToCache
//                    }
//                }
//            }
//        }
//    }
//}
