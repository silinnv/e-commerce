//
//  ProductDatabase.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct ProductDatabase: ProductDatabaseProtocol {
    
    var ID:         String
       
    var name:       String
       
    var price:      Double
       
    var weight:     Double
       
    var imageURL:   URL?
}

extension ProductDatabase: Mappable {
    
    init?(key: String, dictionary: [String : Any]) {
        
        guard let name          = dictionary["Name"] as? String,
            let priceString     = dictionary["Price"] as? String,
            let price           = Double(priceString),
            let weightString    = dictionary["BruttoWeight"] as? String,
            let weight          = Double(weightString),
            let imageStringURL  = dictionary["ImageBigUrl"] as? String else { return nil }
        
        self.ID                 = key
        self.name               = name
        self.weight             = weight
        self.imageURL           = URL(string: imageStringURL)
        self.price              = price
    }
}
