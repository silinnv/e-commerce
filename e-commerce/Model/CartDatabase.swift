//
//  CartDatabase.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct CartDatabase: CartDatabaseProtocol {
    
    var ID:         String

    var name:       String

    var type:       CartType

    var customers:  [String : Buying]
}

extension CartDatabase: Mappable {
    
    init?(key: String, dictionary: [String : Any]) {
        
        guard let name              = dictionary["Name"] as? String,
            let typeOfCartString    = dictionary["Type"] as? String,
            let customerDictionary  = dictionary["Users"] as? [String: Any] else { return nil }
        
        let customers = customerDictionary
            .compactMap { (key, data) -> Buying? in
                guard let customerData = data as? [String: Any] else { return nil }
                return Customer(key: key, dictionary: customerData)
            }
            .reduce(into: [String: Buying]()) { resultDictionary, customer in
                resultDictionary[customer.ID] = customer
            }
        
        switch typeOfCartString {
        case CartType.privates.rawValue:
            type = .privates
        case CartType.shared.rawValue:
            type = .shared
        default:
            return nil
        }
        
        self.ID         = key
        self.name       = name
        self.customers  = customers
    }
}
