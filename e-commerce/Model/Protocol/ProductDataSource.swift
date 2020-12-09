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

    var myCount:        Double       { get set }

    var allCount:       Double       { get set }

    var myPrice:        Double       { get }

    var allPrice:       Double       { get }

    var myWeight:       Double       { get }

    var allWeight:      Double       { get }

    var myAddedDate:    Date         { get set }

    var otherAddedDate: Date         { get set }
    
    var productOwner:   ProductOwner { get set }
}
