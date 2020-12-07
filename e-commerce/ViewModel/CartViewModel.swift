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
    
    private let bag             = DisposeBag()
    private let userDefault     = UserDefaultService.shared
    private let network         = NetworkService.shared
    private let dataManager     = DataManager.shared
    
    private let productSubject  = PublishSubject<[ProductDatabaseProtocol]>()
    
    let cartDataSubject         = PublishSubject<CartDataSource>()
    let productData             = PublishSubject<[SectionModel<String, ProductDataSource>]>()
    
    func setup() {
        setupProductDatabase()
        setupProductDataSource()
    }
    
    func setupProductDatabase() {
        dataManager
            .cartDatabaseSubject
            .map { Array($0.productKeys) }
            .subscribe(onNext: { [unowned self] productKeys in
                self.network
                    .requestProducts(forKeys: productKeys)
                    .bind { self.productSubject.onNext($0) }
                    .disposed(by: self.bag)
            }).disposed(by: bag)
    }
    
    func setupProductDataSource() {
        Observable
            .zip(dataManager.cartDatabaseSubject.asObserver(), productSubject.asObserver())
            .compactMap { [unowned self] cartDatabase, productsDatabase in
                let uid = self.userDefault.currentUserID
                let prodDictionary = productsDatabase
                    .reduce(into: [String: ProductDatabase]()) { $0[$1.ID] = $1 }
                let cartDataSource = CartData(cart: cartDatabase,
                                              products: prodDictionary,
                                              currentUID: uid)
                return cartDataSource
            }
            .bind { [unowned self] in self.cartDataSubject.onNext($0) }
            .disposed(by: bag)
        
        Observable
            .zip(cartDataSubject.asObserver(), productSubject.asObserver())
            .bind { [unowned self] cart, products in
                let productsModel = self.getProductsData(products: products, cart: cart)
                let myProducts = productsModel
                    .filter { $0.myCount > 0 }
                    .sorted { $0.myAddedDate < $1.myAddedDate }
                let otherProducts = productsModel
                    .filter { $0.myCount == 0 && $0.allCount > 0 }
                    .sorted { $0.otherAddedDate < $1.otherAddedDate }
                
                self.productData.onNext([
                    SectionModel(model: "My products", items: myProducts),
                    SectionModel(model: "Other product", items: otherProducts)
                ])
            }
            .disposed(by: bag)
    }

    private func getProductsData(products: [ProductDatabaseProtocol], cart: CartDataSource) -> [ProductDataSource] {
        
        var productsData = products
            .compactMap { ProductData(product: $0) }
            .reduce(into: [String: ProductData]()) { resultDictionary, product in
                resultDictionary[product.ID] = product
        }
        
        for customer in cart.customers {
            for prodSKU in customer.value.products {
                guard productsData[prodSKU.ID] != nil else { continue }
                
                productsData[prodSKU.ID]!.allCount += prodSKU.count
                productsData[prodSKU.ID]!.otherAddedDate = min(
                    productsData[prodSKU.ID]!.otherAddedDate,
                    prodSKU.addedDate)
                
                if customer.key == self.userDefault.currentUserID {
                    productsData[prodSKU.ID]!.myCount += prodSKU.count
                    productsData[prodSKU.ID]!.myAddedDate = prodSKU.addedDate
                }
            }
        }
        
        return Array(productsData.values)
    }
}
