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

    let productData             = PublishSubject<[SectionModel<HeaderViewModel, ProductDataSource>]>()
    let cartDataSubject         : ReplaySubject<CartDataSource>!
    
    init() {
        cartDataSubject = dataManager.cartSubject
    }
    
    // MARK: - Setup
    func setup() {
        setupProductDataSource()
    }
    
    func setupProductDataSource() {
        
        Observable
            .combineLatest(
                dataManager
                    .cartSubject.asObserver(),
                dataManager
                    .productsSubject.asObservable())
            .bind { cart, products in
                let myProducts = products
                    .filter { $0.productOwner == .me}
                    .sorted { $0.name < $1.name }
                let otherProducts = products
                    .filter { $0.productOwner == .other }
                    .sorted { $0.name < $1.name }
                
                let myProductPrice = myProducts.reduce(0, { $0 + $1.myPrice })
                
                // TODO: Fix this. When im added product from other prod list, its my price, no other
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
                
            }.disposed(by: bag)
    }


    
    // MARK: - Bussines Logic
    func changeProductCount(product: ProductDataSource, count: Double) {
        print("cartVM: CHANGE \(product.ID) : \(count) count")

        // TODO: Fix date
        
        network.updateProduct(productID: product.ID, newValue: count, addedDate: Int(product.myAddedDate.timeIntervalSince1970))
    }
}
