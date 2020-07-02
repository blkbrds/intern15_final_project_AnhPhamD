//
//  Networking.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/1/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

struct TagGroupResult {
    var tagGroups: [TagGroup]
}

struct DrinkResult {
    var drinks: [Drink]
}

enum APIResult<T> {
    case failure(String)
    case success(T)
}

typealias APICompletion<T> = (APIResult<T>) -> Void

final class Networking {
    private static var sharedNetworking: Networking = {
        let networking = Networking()
        return networking
    }()
    
    class func shared() -> Networking {
        return sharedNetworking
    }
    
    private init() {}
    
    func getCategory(urlString: String, completion: @escaping APICompletion<TagGroupResult>) {
        guard let url = URL(string: urlString) else {
            completion(.failure("URL Error"))
            return
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error.localizedDescription))
                } else {
                    if let data = data {
                        var tagGroups: [TagGroup] = []
                    
                        let json = data.toJSON()
                        guard let drinksJS = json["drinks"] as? [JSON] else {
                            return
                        }
                        
                        drinksJS.forEach { drink in
                            let item = TagGroup(json: drink)
                            tagGroups.append(item)
                        }
                        completion(.success(TagGroupResult(tagGroups: tagGroups)))
                    } else {
                        completion(.failure("Data format is error"))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getDrinkForCategory(urlString: String, completion: @escaping APICompletion<DrinkResult>) {
        guard let url = URL(string: urlString) else {
            completion(.failure("URL error"))
            return
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error.localizedDescription))
                } else {
                    if let data = data {
                        var drinksResult: [Drink] = []
                        
                        let json = data.toJSON()
                        guard let drinksJS = json["drinks"] as? [JSON] else {
                            return
                        }
                        
                        drinksJS.forEach { drink in
                            let item = Drink(json: drink)
                            drinksResult.append(item)
                        }
                        completion(.success(DrinkResult(drinks: drinksResult)))
                    } else {
                        completion(.failure("Data format is error"))
                    }
                }
            }
        }
        task.resume()
    }
    
    func getDrinkImageForCategories(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil)
                } else {
                    if let data = data {
                        let image = UIImage(data: data)
                        completion(image)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}
