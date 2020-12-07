//
//  ProductSKU.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct ProductSKU: ProductSKUProtocol {
    
    let ID:         String
    
    var count:      Double
    
    let addedDate:  Date
}

extension ProductSKU: Mappable {
    
    init?(key: String, dictionary: [String : Any]) {
        guard let count         = dictionary["Count"] as? Double,
            let addedDateInt    = dictionary["AddedDate"] as? Int else { return nil }
        
        let addedDate = Date(timeIntervalSince1970: TimeInterval(addedDateInt))
        
        self.ID         = key
        self.count      = count
        self.addedDate  = addedDate
    }
}
