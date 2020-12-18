//
//  TestDataManager.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/10/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TestDataManager {
    
    static let shared               = TestDataManager()
    
    // MARK: - Properties
    private let network             = NetworkService.shared
    private let userDefault         = UserDefaultService.shared
    private let bag                 = DisposeBag()
    
    let cartDatabaseSubject         = ReplaySubject<CartDatabaseProtocol>.create(bufferSize: 1)
    let productDatabaseSubject      = ReplaySubject<[String: ProductDatabaseProtocol]>.create(bufferSize: 1)
    
    
    let cartSubject                 = ReplaySubject<CartDataSource>.create(bufferSize: 1)
    let productsSubject             = ReplaySubject<[ProductDataSource]>.create(bufferSize: 1)
    let isLoaded                    = BehaviorRelay<Bool>(value: true)
    
    private var productBuffer:      [String: ProductDatabaseProtocol] = [:]
    private var myProductKeys:      Set<String>? = nil
    
    // MARK: - Init
    private init() {
        setup()
        
        let currentCartID = userDefault.currentCartID
        getRequestCartID(byKey: currentCartID) { [unowned self] requestCartID in
            guard let requestCartID = requestCartID else { return }
            self.subscribeOnCart(byKey: requestCartID)
        }
    }
    
    func setup() {
        
        Observable
            .zip(cartSubject.asObserver(), productDatabaseSubject.asObservable())
            .subscribe(onNext: { [unowned self] cartData, productDatabase in
                
                print("ZIP cartDATA \(cartData.name) & prodDB \(productDatabase.values.count)")
                
                guard let myProductKeys = self.myProductKeys else { return }
                
                var resultProductsData = productDatabase.values
                    .compactMap { ProductData(product: $0) }
                    .reduce(into: [String: ProductDataSource]()) { $0[$1.ID] = $1 }
                
                for customer in cartData.customers {
                    for customerProduct in customer.value.products {
                        guard var product = resultProductsData[customerProduct.ID] else { continue }
                        
                        let uid = self.userDefault.currentUserID
                        let olderAddedDate = min(product.otherAddedDate, customerProduct.addedDate)
                        
                        product.allCount += customerProduct.count
                        product.otherAddedDate = olderAddedDate
                        product.productOwner = (myProductKeys.contains(product.ID)) ? .me : .other
                        product.myAddedDate = (myProductKeys.contains(product.ID)) ? customerProduct.addedDate : olderAddedDate
                        product.myCount = (customer.key == uid) ? customerProduct.count : .zero
                        
                        resultProductsData[customerProduct.ID] = product
                    }
                }
                
                self.productsSubject.onNext(Array(resultProductsData.values))
            })
            .disposed(by: bag)
        
        Observable
            .zip(cartDatabaseSubject.asObserver(), productDatabaseSubject.asObservable())
            .compactMap{ [unowned self] cart, productDictionary in
                print("ZIP cartDB \(cart.name) & prodDB \(productDictionary.values.count)")
                let uid = self.userDefault.currentUserID
                return CartData(cart: cart, products: productDictionary, currentUID: uid)
            }
            .subscribe(onNext: { [unowned self] in self.cartSubject.onNext($0) })
            .disposed(by: bag)
        
        cartDatabaseSubject
            .map { $0.productKeys }
            .subscribe(onNext: { [unowned self] productKeys in
                print("cartDB have \(productKeys)")
//                self.requestProducts(byKeys: productKeys)
            }).disposed(by: bag)
    }
    
    func getRequestCartID(byKey cartID: String, _ complition: @escaping (String?) -> Void) {
        isLoaded.accept(true)
        network.requestCartKeys { [unowned self] cartKeys in
            self.isLoaded.accept(false)
            guard !cartKeys.isEmpty else { return }
            let requestCartID = cartKeys.contains(cartID) ? cartID : cartKeys.first!
            complition(requestCartID)
        }
    }
    
    // MARK: - Cart
    private func subscribeOnCart(byKey cartKey: String) {
        
        print("subCart", cartKey)
        
        network.subscribeOnCart(forKey: cartKey) { cart in
            self.userDefault.currentCartID = cart.ID
            self.cartDatabaseSubject.onNext(cart)
        }
    }
    
    private func subscribeOnCart2(byKey cartKey: String) {
        
        network.subscribeOnCart(forKey: cartKey) { [unowned self] cart in
            self.userDefault.currentCartID = cart.ID
            self.requestProductsiInBuff(forCart: cart)
        }
    }
    
    
    
//    func resubscribeOnCart(byKey cartKey: String) {
//        resetProductData()
//        network.unsubscribeFromCart(byKey: cartKey)
//        subscribeOnCart(byKey: cartKey)
//    }
    
    func resubscribeOnCart(withNewCartKey newCartID: String) {
        guard !newCartID.isEmpty else { return }
        network.unsubscribeFromCart(byKey: userDefault.currentCartID)
        subscribeOnCart(byKey: newCartID)
    }
    
    func resubscribeOnCart(withNewCart newCart: CartDatabaseProtocol) {
        let newCartID = newCart.ID
        resetProductData()
        resubscribeOnCart(withNewCartKey: newCartID)
    }
    
    // MARK: - Product
    
    private func requestProductsiInBuff(forCart cart: CartDatabaseProtocol) {
        var currentProductDictionary = productBuffer
        let currentProductKeys = Set(currentProductDictionary.keys)
        let neededProductKeys = cart.productKeys
        let newProductKeys = neededProductKeys.subtracting(currentProductKeys)
        
        network
            .requestProducts(forKeys: Array(newProductKeys))
            .map { newProducts in
                newProducts
                    .reduce(into: [String: ProductDatabaseProtocol]()) { resultProductDictionary, product in
                        resultProductDictionary[product.ID] = product
                    }
            }
            .subscribe(onNext: { [unowned self] newProductDictionary in
                for newProduct in newProductDictionary {
                    currentProductDictionary[newProduct.key] = newProduct.value
                }
                self.productBuffer = currentProductDictionary
                self.cartDatabaseSubject.onNext(cart)
                
            }).disposed(by: bag)
    }
//    private func requestProducts(byKeys productKeys: Set<String>) {
//
//        var currentProductDictionary = productDatabaseSubject.value
//        let currentProductKeys = Set(currentProductDictionary.keys)
//        let newProductKeys = myProductKeys == nil ? productKeys : productKeys.subtracting(currentProductKeys)
//
//        guard !newProductKeys.isEmpty else {
//            productDatabaseSubject.accept(currentProductDictionary)
//            return
//        }
//
//        network
//            .requestProducts(forKeys: Array(newProductKeys))
//            .map { newProducts in
//                newProducts
//                    .reduce(into: [String: ProductDatabaseProtocol]()) { resultProductDictionary, product in
//                        resultProductDictionary[product.ID] = product
//                    }
//            }
//            .subscribe(onNext: { [unowned self] newProductDictionary in
//                for newProduct in newProductDictionary {
//                    currentProductDictionary[newProduct.key] = newProduct.value
//                }
//                self.productDatabaseSubject.accept(currentProductDictionary)
//            }).disposed(by: bag)
//    }
    
    private func resetProductData() {
        myProductKeys = nil
    }
    
    // MARK: - My products
    
    private var isResetData: Bool {
        myProductKeys == nil
    }
    
    private func setMyProductKeysIfNeeded(cart: CartDatabaseProtocol) {
        let uid = userDefault.currentUserID
        
        if let me = cart.customers[uid],
            myProductKeys == nil {
            let myKeys = me.products
                .filter { $0.count > 0 }
                .reduce(into: Set<String>()) { $0.insert($1.ID) }
            myProductKeys = myKeys
            print(myProductKeys, "¡™£¢∞§¶•ª")
        }
    }
}
