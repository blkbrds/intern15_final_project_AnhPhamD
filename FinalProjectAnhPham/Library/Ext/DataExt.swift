//
//  DataExt.swift
//  FinalProjectAnhPham
//
//  Created by PCI0012 on 7/1/20.
//  Copyright © 2020 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

extension Data {
    func toJSON() -> JSON {
        var json: [String: Any] = [:]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? JSON {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
    
    func toArrayJSON() -> [JSON] {
        var json: [[String: Any]] = [[:]]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [JSON] {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
}
