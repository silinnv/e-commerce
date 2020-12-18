//
//  SubCategory.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

enum SubCategotyStyle {
    case normal, bold
}

struct SubCategoty {
    let ID:             String
    let name:           String
    let header:         String
    let productKeys:    [String]
    var style:          SubCategotyStyle = .normal
}

extension SubCategoty: Mappable {
    init?(key: String, dictionary: [String : Any]) {
        guard let name      = dictionary["Name"] as? String,
            let products    = dictionary["Products"] as? [String: Any] else { return nil }
        
        let productKeys     = Array(products.keys)
        
        self.ID             = key
        self.name           = name
        self.header         = name
        self.productKeys    = productKeys
    }
}
