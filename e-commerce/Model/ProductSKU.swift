//
//  ProductSKU.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct ProductSKU: ProductSKUProtocol {
    
    let ID:     String
    
    var count:  Double
}

extension ProductSKU: Mappable {
    
    init?(key: String, dictionary: [String : Any]) {
        guard let count = dictionary["Count"] as? Double else { return nil }
        self.ID     = key
        self.count  = count
    }
}
