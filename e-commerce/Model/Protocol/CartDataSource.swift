//
//  CartDataSource.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

protocol CartDataSource: CartDatabaseProtocol {

    var me:         Buying { get }
    
    var myPrice:    Double { get }
    
    var fullPrice:  Double { get }
}
