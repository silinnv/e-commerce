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
import RxDataSources

enum NetworkError: Error {
  
    case cartNotFound
}

class CartViewModel {
    
    private let network         = NetworkService.shared
    private let bag             = DisposeBag()
    private let userDefault     = UserDefaultService.shared
    
    private let productSubject  = PublishSubject<[ProductDatabaseProtocol]>()
    
    let cartDatabaseSubject     = PublishSubject<CartDatabaseProtocol>()
    let cartDataSubject         = PublishSubject<CartDataSource>()
    let productData             = PublishSubject<[SectionModel<String, ProductData>]>()
    
    func setup() {
        setupProducts()
        setupCart()
        subscribeOnCart(withID: userDefault.currentCartID)
    }
    
    private func subscribeOnCart(withID cartID: String) {
        
        cartDatabaseSubject.dispose()
        
        network.requestCartKeys { cartKeys in
            guard let cartKeys = cartKeys, !cartKeys.isEmpty else {
                self.cartDatabaseSubject.onError(NetworkError.cartNotFound)
                return
            }
            let requestCartID = cartKeys.contains(cartID) ? cartID : cartKeys.first!
            self.network.subscribeOnCart(forKey: requestCartID) { cart in
                guard let cart = cart else {
                    self.cartDatabaseSubject.onError(NetworkError.cartNotFound)
                    return
                }
                self.cartDatabaseSubject.onNext(cart)
            }
        }
    }
    
    private func setupCart() {
        
        cartDatabaseSubject
            .subscribe(onNext: { cart in
                let productKeys = cart.productKeys
                self.network.requestProducts(forKeys: Array(productKeys))
                    .bind { products in
                        let prodDictionary = products.reduce(into: [String: ProductDatabase]()) { $0[$1.ID] = $1 }
                        if let cartData = CartData(
                            cart: cart,
                            products: prodDictionary,
                            currentUID: self.userDefault.currentUserID) {
                            self.cartDataSubject.onNext(cartData)
                        }
                    }.disposed(by: self.bag)
            }, onError: { error in
                print(error)
            }).disposed(by: bag)
    }
    
    private func setupProducts() {
        
        cartDataSubject
            .map { Array($0.productKeys) }
            .bind { [unowned self] productKeys in
                self.network
                    .requestProducts(forKeys: productKeys)
                    .bind { self.productSubject.onNext($0) }
                    .disposed(by: self.bag)
            }.disposed(by: bag)
        
        Observable
            .zip(cartDataSubject, productSubject)
            .bind { [unowned self] cart, products in
                let productsModel = self.getProductsData(products: products, cart: cart)
                let myP = productsModel.filter { $0.myCount > 0 }
                let otherP = productsModel.filter { $0.myCount == 0 && $0.allCount > 0 }
                self.productData.onNext([
                    SectionModel(model: "My products", items: myP),
                    SectionModel(model: "Other product", items: otherP)
                ])
                
            }.disposed(by: bag)
    }
    
    private func getProductsData(products: [ProductDatabaseProtocol], cart: CartDataSource) -> [ProductData] {
        
        var productsData = products
            .compactMap { ProductData(product: $0) }
            .reduce(into: [String: ProductData]()) { resultDictionary, product in
                resultDictionary[product.ID] = product
        }
        
        for customer in cart.customers {
            for prodSKU in customer.value.products {
                productsData[prodSKU.ID]?.allCount += prodSKU.count
                if customer.key == self.userDefault.currentUserID {
                    productsData[prodSKU.ID]?.myCount += prodSKU.count
                }
            }
        }
        
        return Array(productsData.values)
    }
}


