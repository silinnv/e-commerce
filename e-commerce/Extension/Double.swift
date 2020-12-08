//
//  Double.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/8/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

extension Double {
    
    func priceFormat() -> String {
        String(format: "%.0lf ₽", self)
    }
    
}
