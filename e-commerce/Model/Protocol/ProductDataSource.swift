//
//  ProductDataSource.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/7/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

enum ProductOwner {
    case me, other
}

protocol ProductDataSource: ProductDatabaseProtocol {

    var myCount:        Double       { get }

    var allCount:       Double       { get }

    var myPrice:        Double       { get }

    var allPrice:       Double       { get }

    var myWeight:       Double       { get }

    var allWeight:      Double       { get }

    var myAddedDate:    Date         { get }

    var otherAddedDate: Date         { get }
    
    var productOwner:   ProductOwner { get }
}
