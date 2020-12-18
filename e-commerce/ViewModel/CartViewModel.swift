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



enum ProductSectionType: String {
    case my = "Мои"
    case other = "Остальные"
}

struct HeaderSectionProductsData {
    
    let title:      String
    
    let myPrice:    String
    
    let allProce:   String

    init(title: String, products: [ProductDataSource]) {
        let myPriceDouble = products.reduce(0) { $0 + $1.myPrice }
        let allPriceDouble = products.reduce(0) { $0 + $1.allPrice }
        
        self.title = title
        self.myPrice = String(format: "%.0lf", myPriceDouble)
        self.allProce = "/ " + allPriceDouble.priceFormat()
    }
}

// MARK: - Cart Contoller Data
struct CartControllerData {
    
    let name:               String
    
    let subtitle:           String
    
    let cartType:           CartType
    
    let myPrice:            String
    
    let allPrice:           String
    
    init(cart: CartDatabaseProtocol, products: [ProductDatabaseProtocol]) {
        let currentUserID       = UserDefaultService.shared.currentUserID
        let productDictionary   = products.reduce(into: [String: ProductDataSource]()) { $0[$1.ID] = $1 }
        
        let myPriceDouble       = cart.price(forCustomer: currentUserID, withProducts: productDictionary)
        let allPriceDouble      = cart.fullPrice(withProducts: productDictionary)
        
        let customerWord        = "участник"
        let customerCount       = cart.customers.count
        var customerSuffix:     String
        
        switch customerCount % 10 {
        case 0, 5...9 : customerSuffix = "ов"
        case 2...4:     customerSuffix = "a"
        default:        customerSuffix = ""
        }
        
        if cart.type == .privates {
            allPrice = " ₽"
            subtitle = "Личная корзина"
        } else {
            allPrice = "/ " + allPriceDouble.priceFormat()
            subtitle = "\(customerCount) \(customerWord)\(customerSuffix)"
        }
        
        self.name       = cart.name
        self.cartType   = cart.type
        self.myPrice    = String(format: "%.0lf", myPriceDouble)
    }
}

// MARK: - View Model 2
class CartViewModel2 {
    private let dataManager         = TestDataManager002.shared
    
    private let bag                 = DisposeBag()
    private let userDefault         = UserDefaultService.shared
    private let network             = NetworkService.shared
    
    private let cartDatabaseSubject = TestDataManager002.shared.cartDatabaseSubject
    private let prodDatabaseSubject = PublishSubject<[ProductDatabaseProtocol]>()
    
    private let myProductKeys       = TestDataManager002.shared.myProductKeysSubject
    
    let cartControllerData          = ReplaySubject<CartControllerData>.create(bufferSize: 1)
    let productData                 = PublishSubject<[SectionModel<HeaderSectionProductsData, ProductDataSource>]>()
    
    func setup() {
        Observable
            .zip(cartDatabaseSubject.asObserver(), prodDatabaseSubject.asObserver())
            .subscribe(onNext: { [unowned self] cart, products in
                let productSectionsData = self.createProductSections(cart: cart, products: products)
                    .map { SectionModel(model: $0.0, items: $0.1) }
                self.productData.onNext(productSectionsData)
                
                let cartControllerData = CartControllerData(cart: cart, products: products)
                self.cartControllerData.onNext(cartControllerData)
            })
            .disposed(by: bag)
        
        cartDatabaseSubject
            .subscribe(onNext: { [unowned self] cart in
                self.dataManager
                    .requestProducts(
                        byKeys: cart.productKeys,
                        productSubject: self.prodDatabaseSubject
                    )
            }).disposed(by: bag)
    }
    
    func changeProductCount(product: ProductDataSource, count: Double) {
        network.updateProduct(
            productID: product.ID,
            newValue: count,
            addedDate: Int(product.myAddedDate.timeIntervalSince1970)
        )
    }
    
    private func getProductDictionary(forCart cart: CartDatabaseProtocol, withProducts products: [ProductDatabaseProtocol]) -> [String: ProductDataSource] {
        var productDictionary = products.reduce(into: [String: ProductDataSource]()) { dictionary, product in
            dictionary[product.ID] = ProductData(product: product)
        }
        
        for customer in cart.customers.values {
            for productInfo in customer.products {
                if productDictionary[productInfo.ID] == nil { continue }
                productDictionary[productInfo.ID]!.allCount += productInfo.count
                if customer.ID == self.userDefault.currentUserID {
                    productDictionary[productInfo.ID]!.myCount += productInfo.count
                }
            }
        }
        return productDictionary
    }
    
    private func createProductSections(cart: CartDatabaseProtocol, products: [ProductDatabaseProtocol]) -> [(HeaderSectionProductsData, [ProductDataSource])] {
        var productSections = [(HeaderSectionProductsData, [ProductDataSource])]()
        let productDictionary = self.getProductDictionary(forCart: cart, withProducts: products)
        
        let myProductsDictionary = productDictionary
            .filter { self.myProductKeys.value != nil && self.myProductKeys.value!.contains($0.key) }
        let myProducts = myProductsDictionary.values.sorted { $0.name < $1.name }
        let myProductsHeader = HeaderSectionProductsData(title: ProductSectionType.my.rawValue, products: myProducts)
        productSections.append((myProductsHeader, myProducts))
        
        if cart.type == .shared {
            let otherProducts = productDictionary
                .filter { myProductsDictionary[$0.key] == nil }
                .values
                .sorted { $0.name < $1.name }
            let otherProductsHeader = HeaderSectionProductsData(title: ProductSectionType.other.rawValue, products: otherProducts)
            productSections.append((otherProductsHeader, otherProducts))
        }
        return productSections
    }
}

// MARK: - Old View Model
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
                
                let myProductPrice = (myProducts + otherProducts).reduce(0) { $0 + $1.myPrice }
                
                // TODO: Fix this. When im added product from other prod list, its my price, no other
                let otherProductPrice = otherProducts
                    .filter { $0.myCount == .zero }
                    .reduce(0) { $0 + $1.allPrice }
                
                let myProductHeader = HeaderViewModel(
                    title: "Мои продукты",
                    price: String(format: "%.0lf ₽", myProductPrice),
                    cartType: cart.type)
                
                let otherProductHeader = HeaderViewModel(
                    title: "Остальные продукты",
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
