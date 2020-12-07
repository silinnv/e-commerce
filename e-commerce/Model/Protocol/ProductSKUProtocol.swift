//
//  ProductSKUProtocol.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

protocol ProductSKUProtocol {
    
    var ID:         String  { get }
    
    var count:      Double  { get }
    
    var addedDate:  Date    { get }
}
