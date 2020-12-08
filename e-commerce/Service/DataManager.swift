//
//  DataManager.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/5/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DataManager {
    
    // MARK: - Properties
    static let shared: DataManager = {
        DataManager()
    }()
    
    private let network         = NetworkService.shared
    private let userDefault     = UserDefaultService.shared
    private let bag             = DisposeBag()
    
    var currentCartID:          String!
    let cartDatabaseSubject     = ReplaySubject<CartDatabaseProtocol>.create(bufferSize: 1)
    let productDatabaseSubject  = BehaviorRelay<[ProductDatabaseProtocol]>.init(value: [])
    var productKeys             = Set<String>()
    var isLoaded                = BehaviorRelay<Bool>(value: true)
    
    // MARK: - Init
    private init() {
        currentCartID = userDefault.currentCartID
        initSubscribeCart(byKey: currentCartID)
    }
    
    func initSubscribeCart(byKey cartID: String) {
        getRequestCartID(byKey: currentCartID) { [unowned self] cartID in
            guard let requestCartID = cartID else { return }
            self.subscribeOnCart(forKey: requestCartID)
        }
    }
    
    func subscribeOnCart(forKey key: String) {
        isLoaded.accept(true)
        network.subscribeOnCart(forKey: key) { [unowned self] cart in
            self.isLoaded.accept(false)
            self.currentCartID = cart.ID
            self.userDefault.currentCartID = cart.ID
            self.cartDatabaseSubject.onNext(cart)
        }
    }
    
    // MARK: - Cart
    func getRequestCartID(byKey cartID: String, _ complition: @escaping (String?) -> Void) {
        isLoaded.accept(true)
        network.requestCartKeys { [unowned self] cartKeys in
            self.isLoaded.accept(false)
            guard !cartKeys.isEmpty else { return }
            let requestCartID = cartKeys.contains(cartID) ? cartID : cartKeys.first!
            complition(requestCartID)
        }
    }
    
    func resubscribeOnCart(withNewCartKey newCartID: String) {
        guard !newCartID.isEmpty else { return }
        network.unsubscribeFromCart(byKey: currentCartID)
        subscribeOnCart(forKey: newCartID)
    }
    
    func resubscribeOnCart(withNewCart newCart: CartDatabaseProtocol) {
        cartDatabaseSubject.onNext(newCart)
        let newCartID = newCart.ID
        resubscribeOnCart(withNewCartKey: newCartID)
    }
    
    // MARK: - Product
    func requestProducts(byKeys newKeys: Set<String>) {
        let newProductKeys = newKeys.subtracting(productKeys)
        productKeys = productKeys.union(newProductKeys)
        
        network.requestProducts(forKeys: Array(newProductKeys))
            .subscribe(onNext: { [unowned self] newProducts in
                for prod in newProducts { print("LOAD", prod.name) }
                let oldProducts = self.productDatabaseSubject.value
                let products = newProducts + oldProducts
                self.productDatabaseSubject.accept(products)
            }).disposed(by: bag)
    }
    
}
