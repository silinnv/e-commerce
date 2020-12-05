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
    
    private init() {}
    static let shared: DataManager = {
        DataManager()
    }()
    
    // MARK: - Properties
    private let network             = NetworkService.shared
    private let userDefault         = UserDefaultService.shared
    
    let cartDatabaseSubject         = PublishSubject<CartDatabaseProtocol>()
    let cartDataSourseSubject       = PublishSubject<CartDataSource>()
    let productDatabaseSubject      = PublishSubject<ProductDatabase>()
    let productDataSourceSubject    = PublishSubject<ProductData>()
    
    // MARK: - Cart
    func requestCartKeys() -> Void {
        
    }
    
    func requestCart(byKey key: String) {
        // onNext()
    }
    
    func subscribeOnCart(byKey key: String) {
        // onNext()
    }
    
    func requestCarts(byKeys keys: String) -> Void {
        
    }
    
    // MARK: - Product
    func requestProduct(byKey key: String) -> Void {
        
    }
    
    func requestProducts(byKeys keys: String) {
        // onNext()
    }
}
