//
//  CartDatabaseProtocol.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

protocol CartDatabaseProtocol {
    
    var ID:         String              { get }
    
    var name:       String              { get }
    
    var type:       CartType            { get }
    
    var customers:  [String: Buying]    { get }
}

extension CartDatabaseProtocol {
    
    var productKeys: Set<String> {
        customers
            .values
            .reduce(Set<String>()) { set, customer in
                set.union(customer.productKeys)
        }
    }
    
    func price(forCustomer customerID: String, withProducts productDictionary: [String: ProductDatabaseProtocol]) -> Double {
        guard let customer = customers[customerID] else { return .zero }
        return customer.totalPriceOfProducts(for: productDictionary)
    }
    
    func fullPrice(withProducts productDictionary: [String: ProductDatabaseProtocol]) -> Double {
        customers
            .values
            .reduce(.zero) { resultPrice, customer in
                resultPrice + customer.totalPriceOfProducts(for: productDictionary)
            }
    }
}
