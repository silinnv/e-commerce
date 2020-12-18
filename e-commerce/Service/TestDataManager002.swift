//
//  TestDataManager002.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/16/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartDataManager {
    
    static let shared           = CartDataManager()
    
    // MARK:  Properties
    private let network         = NetworkService.shared
    private let userDefault     = UserDefaultService.shared
    private let bag             = DisposeBag()
    
    let cartDatabaseSubject     = ReplaySubject<CartDatabaseProtocol>.create(bufferSize: 1)
    let myProductKeys           = BehaviorRelay<Set<String>?>(value: nil)
    
    // MARK: Init
    private init() {
        setup()
    }
    
    private func setup() {
        let currentCartID = userDefault.currentCartID
        network.requestCartKeys { [unowned self] cartKeys in
            guard !cartKeys.isEmpty else { return }
            let requestedCartID = cartKeys.contains(currentCartID) ? currentCartID : cartKeys.first!
            self.subscribeOnCart(byKey: requestedCartID)
        }
    }
    
    // MARK: Subscribe
    func subscribeOnCart(byKey cartKey: String) {
        guard !cartKey.isEmpty else { return }
        
        network.subscribeOnCart(forKey: cartKey) { [unowned self] cart in
            
            if self.myProductKeys.value == nil,
                let me = cart.customers[self.userDefault.currentUserID] {
                let myProductKeys = me
                    .products
                    .filter { $0.count > 0 }
                    .reduce(into: Set<String>()) { $0.insert($1.ID) }
                self.myProductKeys.accept(myProductKeys)
            }
            
            self.userDefault.currentCartID = cartKey
            self.cartDatabaseSubject.onNext(cart)
        }
    }
    
    func resubscribeOnCart(withNewCartKey newCartID: String) {
        guard !newCartID.isEmpty else { return }
        myProductKeys.accept(nil)
        network.unsubscribeFromCart(byKey: userDefault.currentCartID)
        subscribeOnCart(byKey: newCartID)
    }
    
    func resubscribeOnCart(withNewCart newCart: CartDatabaseProtocol) {
        let newCartID = newCart.ID
        resubscribeOnCart(withNewCartKey: newCartID)
    }
    
}

class ProductsDataManager {
    
    static let shared               = ProductsDataManager()
    
    // MARK: - Properties
    private var productBuff         = [String: ProductDatabaseProtocol]()
    private let network             = NetworkService.shared
    private let userDefault         = UserDefaultService.shared
    private let bag                 = DisposeBag()
    
    private init() { }
    
    func requestProducts(byKeys productKeys: Set<String>, _ complition: @escaping ([ProductDatabaseProtocol]) -> Void) {
        let buffProductKeys = Set(productBuff.keys)
        let newProductKeys = productKeys.subtracting(buffProductKeys)

        if !newProductKeys.isEmpty {
            loadProductsInBuff(byKeys: newProductKeys) {
                let products = productKeys.compactMap { self.productBuff[$0] }
                complition(products)
                return
            }
        } else {
            let products = productKeys.compactMap { self.productBuff[$0] }
            complition(products)
        }
    }
    
    func reloadProducts(byKeys productKeys: Set<String>, _ complition: @escaping () -> Void) {
        for productKey in productKeys {
            productBuff[productKey] = nil
        }
        loadProductsInBuff(byKeys: productKeys) { complition() }
    }
    
    private func loadProductsInBuff(byKeys productKeys: Set<String>, _ complition: @escaping () -> Void) {
        network
            .requestProducts(forKeys: Array(productKeys))
            .subscribe(onNext: { [unowned self] products in
                for product in products {
                    self.productBuff[product.ID] = product
                }
                complition()
            }).disposed(by: bag)
    }
    
}

class TestDataManager002 {
    
    static let shared               = TestDataManager002()

    private let cartDataManager     = CartDataManager.shared
    private let productDataManager  = ProductsDataManager.shared
    private let bag                 = DisposeBag()
    
    let cartDatabaseSubject         = CartDataManager.shared.cartDatabaseSubject
    let myProductKeysSubject        = CartDataManager.shared.myProductKeys
    
    private init() { }
    
    func subscribeOnCart(byKey cartID: String) {
        cartDataManager.subscribeOnCart(byKey: cartID)
    }
    
    func resubscribeOnCart(withNewCart newCart: CartDatabaseProtocol) {
        productDataManager.reloadProducts(byKeys: newCart.productKeys) {
            self.cartDataManager.resubscribeOnCart(withNewCart: newCart)
        }
    }
    
    func requestProducts(byKeys productKeys: Set<String>, _ complition: @escaping ([ProductDatabaseProtocol]) -> Void) {
        productDataManager.requestProducts(byKeys: productKeys) { products in
            complition(products)
        }
    }
    
    func requestProducts(byKeys productsKeys: Set<String>, productSubject: PublishSubject<[ProductDatabaseProtocol]>) {
        requestProducts(byKeys: productsKeys) { products in
            productSubject.onNext(products)
        }
    }
}
