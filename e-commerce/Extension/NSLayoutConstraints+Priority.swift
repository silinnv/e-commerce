//
//  NSLayoutConstraints+Priority.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func priority(_ rawValue: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(rawValue)
        return self
    }
}
