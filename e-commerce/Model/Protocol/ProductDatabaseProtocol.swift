//
//  ProductDatabaseProtocol.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

protocol ProductDatabaseProtocol {
 
    var ID:         String { get }
    
    var name:       String { get set }
    
    var price:      Double { get }
    
    var weight:     Double { get }
    
    var imageURL:   URL? { get }
}
