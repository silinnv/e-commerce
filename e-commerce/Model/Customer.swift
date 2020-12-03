//
//  Customer.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct Customer:    Buying {
    
    var ID:         String
    
    var products:   [ProductSKUProtocol]
    
    var isPaid:     Bool
    
    var status:     UserStatus
    
    var inviteDate: Date
}

extension Customer: Mappable {
    
    init?(key: String, dictionary: [String : Any]) {
        guard let productsDictionary    = dictionary["Products"] as? [String: Any],
            let isPaid                  = dictionary["IsPaid"] as? Bool,
            let statusString            = dictionary["Status"] as? String,
            let inviteDateInt           = dictionary["InviteDate"] as? Int else { return nil }
        
        let products = productsDictionary
            .compactMap { (key, data) -> ProductSKUProtocol? in
                guard let productDictionary = data as? [String: Any] else { return nil }
                return ProductSKU(key: key, dictionary: productDictionary)
            }
        
        let inviteDate = Date(timeIntervalSince1970: TimeInterval(inviteDateInt))
        
        switch statusString {
        case UserStatus.owner.rawValue:
            status = UserStatus.owner
        case UserStatus.user.rawValue:
            status = UserStatus.user
        case UserStatus.invited.rawValue:
            status = UserStatus.invited
        default:
            return nil
        }
        
        self.ID         = key
        self.products   = products
        self.isPaid     = isPaid
        self.inviteDate = inviteDate
    }
}
