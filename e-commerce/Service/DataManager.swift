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
    
    private let network     = NetworkService.shared
    private let userDefault = UserDefaultService.shared
    
    var currentCartID:      String!
    var cartDatabaseSubject = ReplaySubject<CartDatabaseProtocol>.create(bufferSize: 1)
    var isLoaded            = BehaviorRelay<Bool>(value: true)
    
    // MARK: - Init
    private init() {
        currentCartID = userDefault.currentCartID
        initSubscribeCart(byKey: currentCartID)
    }
    
    func initSubscribeCart(byKey cartID: String) {
        getRequestCartID(byKey: currentCartID) { [unowned self] cartID in
            guard let requestCartID = cartID else { return }
            self.subscribeOnCart(forKey: requestCartID)
        }
    }
    
    func subscribeOnCart(forKey key: String) {
        isLoaded.accept(true)
        network.subscribeOnCart(forKey: key) { [unowned self] cart in
            self.isLoaded.accept(false)
            self.currentCartID = cart.ID
            self.userDefault.currentCartID = cart.ID
            self.cartDatabaseSubject.onNext(cart)
        }
    }
    
    // MARK: - Cart
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
        network.unsubscribeFromCart(byKey: currentCartID)
        subscribeOnCart(forKey: newCartID)
    }
    
    func resubscribeOnCart(withNewCart newCart: CartDatabaseProtocol) {
        cartDatabaseSubject.onNext(newCart)
        let newCartID = newCart.ID
        resubscribeOnCart(withNewCartKey: newCartID)
    }
    
}
