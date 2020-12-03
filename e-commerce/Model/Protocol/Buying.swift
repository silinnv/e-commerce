//
//  Buying.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

protocol Buying {
    
    var ID:         String                  { get }
    
    var products:   [ProductSKUProtocol]    { get }
    
    var isPaid:     Bool                    { get set }
    
    var status:     UserStatus              { get set }
    
    var inviteDate: Date                    { get }
}

extension Buying {
    
    var productKeys: Set<String> {
        products.reduce(into: Set<String>()) { $0.insert($1.ID) }
    }
    
    func totalPriceOfProducts(for productDictionary: [String: ProductDatabaseProtocol]) -> Double {
        products
            .map { productSKU in
                guard let product = productDictionary[productSKU.ID] else { return .zero }
                return product.price * productSKU.count
            }
            .reduce(0, +)
    }
}
