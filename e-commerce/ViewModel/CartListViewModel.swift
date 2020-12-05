//
//  CartListViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/4/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartListViewModel {
    
    private let network                 = NetworkService.shared
    private let bag                     = DisposeBag()
    private let userDefault             = UserDefaultService.shared
    
    public let isLoaded                 = BehaviorSubject<Bool>(value: true)
    public let cartsDataSubject         = PublishRelay<[CartDataSource]>()
    private let cartsDatabaseSubject    = PublishRelay<[CartDatabaseProtocol]>()
    private let productSubject          = PublishRelay<[ProductDatabaseProtocol]>()
    
    func setup() {
        setupRawDataCart()
        setupPreparedCarts()
        loadData()
    }
    
    func loadData() {
        
        network.subscribeOnCartKeys()
            .subscribe(onNext: { [unowned self] cartKeys in
                self.isLoaded.onNext(true)
                self.network.requestCarts(forKeys: cartKeys)
                    .subscribe(onNext: { self.cartsDatabaseSubject.accept($0) })
                    .disposed(by: self.bag)
            }).disposed(by: bag)
    }
    
    private func setupRawDataCart() {
        
        cartsDatabaseSubject
            .subscribe(onNext: { [unowned self] carts in
                let productKeys = carts
                    .reduce(Set<String>()) { $0.union($1.productKeys) }
                self.network.requestProducts(forKeys: Array(productKeys))
                    .subscribe(onNext: { self.productSubject.accept($0) })
                    .disposed(by: self.bag)
            }).disposed(by: bag)
    }
    
    private func setupPreparedCarts() {
        
        Observable
            .zip(cartsDatabaseSubject.asObservable(), productSubject.asObservable())
            .subscribe(onNext: { [unowned self] rawCarts, products in
                self.isLoaded.onNext(false)
                let currentID = self.userDefault.currentUserID
                let productDictionary = products.reduce(into: [String: ProductDatabaseProtocol]()) { $0[$1.ID] = $1 }
                let preparedCarts = rawCarts
                    .compactMap { CartData(
                        cart: $0,
                        products: productDictionary,
                        currentUID: currentID
                    )}
                    .sorted { lftCart, rftCart in
                        guard let lftDate = lftCart.customers[currentID]?.inviteDate,
                            let rftDate = rftCart.customers[currentID]?.inviteDate else { return false }
                        return lftDate < rftDate
                    }
                self.cartsDataSubject.accept(preparedCarts)
            }).disposed(by: bag)
    }
}
