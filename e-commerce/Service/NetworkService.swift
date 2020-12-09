//
//  NetworkService.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import RxSwift
import RxCocoa

class NetworkService {
    
    private let ref = Database.database().reference()
    private let bag = DisposeBag()
    private let userDefault = UserDefaultService.shared
    
    static var shared: NetworkService = {
        NetworkService()
    }()
    
    private init() { }
    
    let cart = PublishSubject<CartDataSource>()
    
    // MARK: - Auth
    func singIn(email: String, password: String, _ clouser: @escaping (Result<String, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            guard let user = user, error == nil else {
                clouser(.failure(error!))
                return
            }
            clouser(.success(user.user.uid))
        }
    }

    // MARK: - Cart key
    func requestCartKeys(_ complition: @escaping ([String]) -> Void) {
        let currentUserID = userDefault.currentUserID
        let refCartList = self.ref.child("Users").child(currentUserID).child("Carts")
        
        refCartList.observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                let cartList = Array(data.map { $0.key })
                complition(cartList)
            }
        }
    }
    
    func subscribeOnCartKeys() -> Observable<[String]> {
        let currentUserID = userDefault.currentUserID
        
        return Observable<[String]>.create { [unowned self] observable in
            let refCartList = self.ref.child("Users").child(currentUserID).child("Carts")
            refCartList.observe(.value) { snapshot in
                if let data = snapshot.value as? [String: Any] {
                    let cartList = Array(data.map { $0.key })
                    observable.onNext(cartList)
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Cart
    func requsetCart(forKey key: String, _ complition: @escaping (CartDatabaseProtocol) -> Void) {
        
        let refCart = self.ref.child("Carts").child(key)
        
        refCart.observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any],
                let cart = CartDatabase(key: key, dictionary: data) {
                complition(cart)
            }
        }
    }
    
    func requestCarts(forKeys keys: [String]) -> Observable<[CartDatabaseProtocol]> {
        Observable.create { [unowned self] observer in
            var counter = 0
            
            for key in keys {
                self.requsetCart(forKey: key) { cart in
                    observer.onNext(cart)
                    counter += 1
                    if keys.count == counter { observer.onCompleted() }
                }
            }
            return Disposables.create()
        }
        .toArray()
        .asObservable()
    }
    
    func subscribeOnCart(forKey key: String, _ complition: @escaping (CartDatabaseProtocol) -> Void) {
        
        guard !key.isEmpty else { return }
        let refCart = self.ref.child("Carts").child(key)
        
        refCart.observe(.value) { snapshot in
            if let data = snapshot.value as? [String: Any],
                let cart = CartDatabase(key: key, dictionary: data) {
                complition(cart)
            }
        }
    }
    
    func unsubscribeFromCart(byKey cartID: String) {
        guard !cartID.isEmpty else { return }
        
        let cartRef = ref.child("Carts").child(cartID)
        cartRef.removeAllObservers()
    }
    
    // MARK: - Product
    func requestProduct(forKey key: String, _ complition: @escaping (ProductDatabaseProtocol) -> Void) {
        let refProduct = self.ref.child("Products").child(key)
        
        refProduct.observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any],
                let product = ProductDatabase(key: key, dictionary: data) {
                complition(product)
            }
        }
    }
    
    func requestProducts(forKeys keys: [String]) -> Observable<[ProductDatabaseProtocol]> {
        Observable.create { [unowned self] observer in
            var productCounter = 0
            
            for key in keys {
                self.requestProduct(forKey: key) { product in
                    productCounter += 1
                    observer.onNext(product)
                    if productCounter == keys.count { observer.onCompleted() }
                }
            }
            return Disposables.create()
        }
        .toArray()
        .asObservable()
    }
    
    func updateProduct(productID: String, newValue: Double, addedDate: Int) {
        let prodRef = ref
            .child("Carts")
            .child(userDefault.currentCartID)
            .child("Users")
            .child(userDefault.currentUserID)
            .child("Products")
            .child(productID)

        prodRef.setValue(["Count": newValue, "AddedDate": addedDate])
    }
    
}
