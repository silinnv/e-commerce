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
    let dataManager = DataManager.shared
    let bag = DisposeBag()
    
    let cartSubject = PublishSubject<CartDatabaseProtocol>()
    
    init () {
        dataManager.cartDatabaseSubject
            .subscribe(onNext: { cart in
                self.cartSubject.onNext(cart)
            }).disposed(by: bag)
    }
    
}
