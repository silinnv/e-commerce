//
//  CartData.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct CartData:    CartDataSource {
    
    var ID:         String
    
    var name:       String
    
    var type:       CartType
    
    var customers:  [String: Buying]
    
    var me:         Buying
    
    var myPrice:    Double
    
    var fullPrice:  Double
}

extension CartData {
    
    init?(cart: CartDatabaseProtocol, products: [String: ProductDatabaseProtocol], currentUID: String) {
        guard let me = cart.customers[currentUID] else { return nil }
        
        self.ID         = cart.ID
        self.name       = cart.name
        self.type       = cart.type
        self.customers  = cart.customers
        self.me         = me
        self.myPrice    = me.totalPriceOfProducts(for: products)
        self.fullPrice  = cart.fullPrice(withProducts: products)
     }
}
