//
//  ProductDataSource.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/5/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct ProductData: ProductDataSource {
    
    var ID:             String
       
    var name:           String
       
    var price:          Double
       
    var weight:         Double
       
    var imageURL:       URL?
    
    var myCount:        Double = 0
    
    var allCount:       Double = 0
    
    var myPrice:        Double { price * myCount }
    
    var allPrice:       Double { price * allCount }
    
    var myWeight:       Double { weight * myCount }
    
    var allWeight:      Double { weight * allCount }
    
    var myAddedDate:    Date = Date(timeIntervalSince1970: 0)
    
    var otherAddedDate: Date = Date(timeIntervalSince1970: 0)
    
    var productOwner:   ProductOwner = .other
}

extension ProductData {
    
    init?(product: ProductDatabaseProtocol) {
        self.ID         = product.ID
        self.name       = product.name
        self.weight     = product.weight
        self.imageURL   = product.imageURL
        self.price      = product.price
    }
}
