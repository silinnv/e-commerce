//
//  Categoty.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

struct Category {
    let name:           String
    let imageURL:       URL?
    var isOpened:       Bool = false
    var subCategories:  [SubCategoty]
}

extension Category: Mappable {
    init?(key: String, dictionary: [String : Any]) {
        guard let name              = dictionary["Name"] as? String,
            let imageStringURL      = dictionary["ImageUrl"] as? String,
            let subCategoriesData   = dictionary["SubCategories"] as? [String: [String: Any]] else { return nil }
        
        let subCategories = subCategoriesData.compactMap { SubCategoty(key: $0.key, dictionary: $0.value) }
        let imageURL = URL(string: imageStringURL)
        
        self.name           = name
        self.subCategories  = subCategories
        self.imageURL       = imageURL
    }
}
