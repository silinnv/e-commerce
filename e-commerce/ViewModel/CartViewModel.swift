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

struct HeaderViewModel {
    
    let title:      String
    
    let price:      String
    
    let cartType:   CartType
}

class CartViewModel {
    
    private let bag             = DisposeBag()
    private let userDefault     = UserDefaultService.shared
    private let network         = NetworkService.shared
    private let dataManager     = DataManager.shared

    let cartDataSubject         = PublishSubject<CartDataSource>()
    let productData             = PublishSubject<[SectionModel<HeaderViewModel, ProductDataSource>]>()
    
    // MARK: - Setup
    func setup() {
        setupProductDatabase()
        setupProductDataSource()
    }
    
    func setupProductDatabase() {
        
        dataManager
            .cartDatabaseSubject
            .map { $0.productKeys }
            .subscribe(onNext: { [unowned self] productKeys in
                self.dataManager.requestProducts(byKeys: productKeys)
            }).disposed(by: bag)
    }
    
    func setupProductDataSource() {
        
        Observable
            .combineLatest(dataManager.cartDatabaseSubject.asObserver(), dataManager.productDatabaseSubject.asObservable())
            .compactMap { [unowned self] cart, products in
                
                print(cart)
                
                let uid = self.userDefault.currentUserID
                let productDictionary = products.reduce(into: [String: ProductDatabase]()) { $0[$1.ID] = $1 }
                let cartDataSource = CartData(cart: cart, products: productDictionary, currentUID: uid)
                return (cartDataSource)
            }
            .bind { [unowned self] in self.cartDataSubject.onNext($0) }
            .disposed(by: bag)
        
        Observable
            .combineLatest(cartDataSubject.asObserver(), dataManager.productDatabaseSubject.asObservable())
            .bind { [unowned self] cart, products in
                let productsModel = self.getProductsData(products: products, cart: cart)
                let myProducts = productsModel
                    .filter { $0.productOwner == .me }
                    .sorted { $0.myAddedDate < $1.myAddedDate }
                let otherProducts = productsModel
                    .filter { $0.productOwner == .other && $0.allCount > 0 }
                    .sorted { $0.otherAddedDate < $1.otherAddedDate }
                
                let myProductPrice = myProducts.reduce(0, { $0 + $1.myPrice })
                let otherProductPrice = otherProducts.reduce(0, { $0 + $1.allPrice })
                
                let myProductHeader = HeaderViewModel(title: "Мои продукты",
                                                      price: String(format: "%.0lf ₽", myProductPrice),
                                                      cartType: cart.type)
                let otherProductHeader = HeaderViewModel(title: "Остальные продукты",
                                                         price: String(format: "%.0lf ₽", otherProductPrice),
                                                         cartType: cart.type)
                
                self.productData.onNext([
                    SectionModel(model: myProductHeader, items: myProducts),
                    SectionModel(model: otherProductHeader, items: otherProducts)
                ])
        }
        .disposed(by: bag)
    }

    private func getProductsData(products: [ProductDatabaseProtocol], cart: CartDataSource) -> [ProductDataSource] {

        var productsDictionary = products
            .compactMap { ProductData(product: $0) }
            .reduce(into: [String: ProductData]()) { resultDictionary, product in
                resultDictionary[product.ID] = product
        }

        for customer in cart.customers {
            for prodSKU in customer.value.products {
                guard productsDictionary[prodSKU.ID] != nil else { continue }
                
                let olderAddedDate = min(productsDictionary[prodSKU.ID]!.otherAddedDate, prodSKU.addedDate)
                productsDictionary[prodSKU.ID]!.otherAddedDate = olderAddedDate
                productsDictionary[prodSKU.ID]!.allCount += prodSKU.count
                
                if customer.key == self.userDefault.currentUserID {
                    productsDictionary[prodSKU.ID]!.productOwner = .me
                    productsDictionary[prodSKU.ID]!.myCount += prodSKU.count
                    productsDictionary[prodSKU.ID]!.myAddedDate = prodSKU.addedDate
                } else if productsDictionary[prodSKU.ID]!.productOwner != .me {
                    productsDictionary[prodSKU.ID]!.productOwner = .other
                }
            }
        }
        
        let productData: [ProductDataSource] = productsDictionary.map { prod in
            let oldName = prod.value.name
            var newProduct = prod.value
            if let range = oldName.range(of: "  ") {
                let newName = oldName[oldName.startIndex ..< range.lowerBound]
                newProduct.name = String(newName)
            }
            return newProduct
        }

        return Array(productData)
    }
    
    // MARK: - Bussines Logic
    func changeProductCount(productID: String, count: Double) {
        print("ref/Carts/\(userDefault.currentCartID)/Users/\(userDefault.currentUserID)/Products/\(productID)/Count = \(count)")
        network.updateProductCount(productID: productID, newValue: count)
    }
}
