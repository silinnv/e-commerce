//
//  CartViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/4/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartViewModel {
    
    private let network         = NetworkService()
    private let bag             = DisposeBag()
    private let userDefault     = UserDefaultService.shared
    
    public let cartSubject      = PublishSubject<CartDataSource>()
    
    private let productSubject  = PublishSubject<[ProductDatabaseProtocol]>()
    
    public func setup() {
        
        cartSubject
            .map { Array($0.productKeys) }
            .bind { [unowned self] productKeys in
                self.network
                    .requestProducts(forKeys: productKeys)
                    .bind { self.productSubject.onNext($0) }
                    .disposed(by: self.bag)
            }.disposed(by: bag)
        
        Observable.zip(cartSubject, productSubject).bind { cart, products in
            print(cart)
            print(products)
        }.disposed(by: bag)
    }
}
