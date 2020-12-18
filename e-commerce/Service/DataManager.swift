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
    
    private let network             = NetworkService.shared
    private let userDefault         = UserDefaultService.shared
    private let bag                 = DisposeBag()
    
    let cartDatabaseSubject         = ReplaySubject<CartDatabaseProtocol>.create(bufferSize: 1)
    let productDatabaseSubject      = BehaviorRelay<[String: ProductDatabaseProtocol]>.init(value: [:])
    
    let cartSubject                 = ReplaySubject<CartDataSource>.create(bufferSize: 1)
    let productsSubject             = BehaviorRelay<[ProductDataSource]>.init(value: [])
    
    var productKeysBuff             = Set<String>()
    var isLoaded                    = BehaviorRelay<Bool>(value: true)
    
    private var myProductKeys:      Set<String>? = nil
    
    // MARK: - Init
    private init() {
        setupSubscribe()
        initSubscribeCart(byKey: userDefault.currentCartID)
    }
    
    func setupSubscribe() {
        
        
//        cartDatabaseSubject.bind { _ in     print(">>>cart      DB") }.disposed(by: bag)
//        productDatabaseSubject.bind { _ in  print(">>>products  DB") }.disposed(by: bag)
//        cartSubject.bind { _ in             print(">>>cart      DATA <<") }.disposed(by: bag)
//        productsSubject.bind { _ in         print(">>>product   DATA <<") }.disposed(by: bag)
        
        cartDatabaseSubject
            .filter { [unowned self] _ in self.myProductKeys == nil }
            .subscribe(onNext: { [unowned self] cart in
                self.setMyProductKeys(cart: cart)
            }).disposed(by: bag)
        
        Observable
            .combineLatest(
                cartSubject.asObserver(),
                productDatabaseSubject.asObservable().filter { $0.count > 0 }
            )
            .bind { [unowned self] cart, productsDatabseDictionary in
                
                print("    combine [cart      DATA | products  DB ]")
                
                guard let myProductKeys = self.myProductKeys else { return }
                
                var productsData = productsDatabseDictionary.values
                    .compactMap { ProductData(product: $0) }
                    .reduce(into: [String: ProductDataSource]()) { $0[$1.ID] = $1 }
                
                for customer in cart.customers {
                    for customerProduct in customer.value.products {
                        
                        guard var productData = productsData[customerProduct.ID] else { continue }
                        
                        let uid = self.userDefault.currentUserID
                        let olderAddedDate = min(productData.otherAddedDate, customerProduct.addedDate)
                        
                        productData.allCount += customerProduct.count
                        productData.otherAddedDate = olderAddedDate
                        
                        if myProductKeys.contains(productData.ID) {
                            productData.productOwner = .me
                            productData.myAddedDate = customerProduct.addedDate
                        } else {
                            productData.productOwner = .other
                        }
                        
                        if customer.key == uid {
                            productData.myCount = customerProduct.count
                        }
                        
                        productsData[customerProduct.ID] = productData
                    }
                }
                
                self.productsSubject.accept(Array(productsData.values))
                
            }
            .disposed(by: bag)
        
        Observable
            .combineLatest(cartDatabaseSubject.asObserver(), productDatabaseSubject.asObservable())
            .compactMap { [unowned self] cart, products in
                print("    combine [cart      DB   | products  DB ]")
                let uid = self.userDefault.currentUserID
                return CartData(cart: cart, products: products, currentUID: uid)
            }
            .subscribe(onNext: { [unowned self] in self.cartSubject.onNext($0) })
            .disposed(by: bag)
    }
    
    func initSubscribeCart(byKey cartID: String) {
        resetProducts()
        getRequestCartID(byKey: userDefault.currentCartID) { [unowned self] cartID in
            guard let requestCartID = cartID else { return }
            self.subscribeOnCart(forKey: requestCartID)
        }
    }
    
    func subscribeOnCart(forKey key: String) {
        isLoaded.accept(true)
        
        network.subscribeOnCart(forKey: key) { [unowned self] cart in
            self.isLoaded.accept(false)
            self.userDefault.currentCartID = cart.ID
            let cartProductKeys = cart.productKeys

            self.requestProducts(byKeys: cartProductKeys)
            self.cartDatabaseSubject.onNext(cart)
        }
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
    
    func resubscribeOnCart(withNewCartKey newCartID: String) {
        guard !newCartID.isEmpty else { return }
        network.unsubscribeFromCart(byKey: userDefault.currentCartID)
        subscribeOnCart(forKey: newCartID)
    }
    
    func resubscribeOnCart(withNewCart newCart: CartDatabaseProtocol) {
//      cartDatabaseSubject.onNext(newCart)
        let newCartID = newCart.ID
        resetProducts()
        resubscribeOnCart(withNewCartKey: newCartID)
    }
    
    func requestProducts(byKeys newKeys: Set<String>) {

        let newProductKeys = newKeys.subtracting(productKeysBuff)
        productKeysBuff = productKeysBuff.union(newProductKeys)
        
        network
            .requestProducts(forKeys: Array(newProductKeys))
            .subscribe(onNext: { [unowned self] newProducts in
                var productDictionary = self.productDatabaseSubject.value
                let newProductDictionary = newProducts
                    .reduce(into: [String: ProductDatabaseProtocol]()) { $0[$1.ID] = $1 }
                for newProduct in newProductDictionary {
                    productDictionary[newProduct.key] = newProduct.value
                }
                
                for key in productDictionary.keys {
                    if !self.productKeysBuff.contains(key) {
                        print("", key)
                        productDictionary[key] = nil
                    }
                 }
                
                self.productDatabaseSubject.accept(productDictionary)
            }).disposed(by: bag)
    }
    
    func resetProducts() {
//        productDatabaseSubject.accept([:])
        productKeysBuff = Set<String>()
        myProductKeys = nil
    }
    
    func setMyProductKeys(cart: CartDatabaseProtocol) {
        let uid = userDefault.currentUserID
        
        if let me = cart.customers[uid],
            myProductKeys == nil {
            let myKeys = me.products
                .filter { $0.count > 0 }
                .reduce(into: Set<String>()) { $0.insert($1.ID) }
            myProductKeys = myKeys
        }
    }
    
    // MARK: - Image
    var imagesDataCaches = NSCache<NSString, NSData>()
    
    func downloadImage(url: URL?, _ complition: @escaping (Data) -> Void) {
        
        guard let imageURL = url else { return }
        let imageKey = imageURL.absoluteString as NSString
        
        if let imageData = imagesDataCaches.object(forKey: imageKey) {
            complition(imageData as Data)
        } else  if let data = try? Data(contentsOf: imageURL) {
            self.imagesDataCaches.setObject(data as NSData, forKey: imageKey)
            complition(data)
        }
    }
}
