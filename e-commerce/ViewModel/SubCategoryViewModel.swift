//
//  SubCategoryViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SubCategoryViewModel {
    private let dataManager         = TestDataManager002.shared
    private let network             = NetworkService.shared
    private let bag                 = DisposeBag()
    
    private let cartDatabase        = TestDataManager002.shared.cartDatabaseSubject
    private let productsDatabase    = BehaviorRelay<[ProductDatabaseProtocol]>(value: [])
    
    var productKeys                 = [String]()
    let productSubject              = BehaviorRelay<[ProductData]>(value: [])
    var isFetchingMore              = true
    
    private var countRequestedProducts = 0
    private var countProductsPerRequest = 8
    private var cartID = UserDefaultService.shared.currentCartID
    
    init() {
        Observable
        .combineLatest(
            cartDatabase.asObservable(),
            productsDatabase.asObservable().skip(1)).bind { cart, products in
                let myID = UserDefaultService.shared.currentUserID
                guard let myProducts = cart.customers[myID]?.products else { return }
                
                let myProductDictionary = myProducts
                    .reduce(into: [String: ProductSKUProtocol]()) { $0[$1.ID] = $1 }
                                
                let productsDataSource = products.map { productDatabase -> ProductData in
                    var product = ProductData(product: productDatabase)
                    if let productInfo = myProductDictionary[product.ID] {
                        product.myCount = productInfo.count
                    } else {
                        product.myCount = 0
                    }
                    return product
                }
                self.productSubject.accept(productsDataSource)
        }.disposed(by: bag)
    }
    
    func requestProductsIfNeeded(indexPath: IndexPath) {
        print("indP", indexPath, countRequestedProducts)
        if indexPath.row >= countRequestedProducts {
            requestProducts()
        }
    }
    
    func requestProducts() {
        if let requestedProductKeys = getRequestedProductKeys() {
            dataManager.requestProducts(byKeys: Set(requestedProductKeys)) { [weak self] requestedProducts in
                if self == nil { return }
                let newProducts = self!.productsDatabase.value + requestedProducts
                self!.productsDatabase.accept(newProducts)
            }
        } else {
            isFetchingMore = false
            print("LIMIT REQUESTED")
        }
    }
    
    func changeProductCountInNetwork(product: ProductData, count: Double) {
        network.updateProduct(productID: product.ID, newValue: count, addedDate: Int(product.myAddedDate.timeIntervalSince1970))
    }
    
    func changeProductCountOnUI(updatedProduct: ProductData, newMyCount: Double) {
        var products = productSubject.value
        
        for i in 0..<products.count {
            if products[i].ID == updatedProduct.ID {
                let oldMyCount = products[i].myCount
                let delta = newMyCount - oldMyCount
                products[i].myCount += delta
                products[i].allCount += delta
                break
            }
        }
        productSubject.accept(products)
    }
    
    private func getRequestedProductKeys() -> [String]? {
        let maxIndex = productKeys.count - 1
        let startIndex = countRequestedProducts
        var endIndex = countRequestedProducts + countProductsPerRequest - 1
        
        if startIndex > maxIndex { return nil }
        endIndex = min(endIndex, maxIndex)
        countRequestedProducts = endIndex + 1
        
        let requestedProductKeys = Array(productKeys[startIndex...endIndex])
        return requestedProductKeys
    }
}
