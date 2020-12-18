//
//  CatalogViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/6/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CatalogViewModel {
    let dataManager     = TestDataManager002.shared
    let network         = NetworkService.shared
    let bag             = DisposeBag()
    
    let cartSubject     = PublishSubject<CartDatabaseProtocol>()
    let catalogSubject  = PublishSubject<[Category]>()
    
    func setup() {
        dataManager.cartDatabaseSubject
            .subscribe(onNext: { [weak self] cart in
                self?.cartSubject.onNext(cart)
            }).disposed(by: bag)
        
        network.requestCatalog() { [weak self] categories in
            let catalog = categories.map { (category: Category) -> Category in
                var updateCategory = category
                let allProducts = category.subCategories.reduce([]) { $0 + $1.productKeys }
                let allProductSubCategory = SubCategoty(
                    ID:             "",
                    name:           "Показать все",
                    header:         category.name,
                    productKeys:    allProducts,
                    style:          .bold)
                
                updateCategory.subCategories.insert(allProductSubCategory, at: 0)
                return updateCategory
            }
            self?.catalogSubject.onNext(catalog)
        }
        
    }
    
}
