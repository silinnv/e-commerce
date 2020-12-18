//
//  CartListViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/4/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CartListViewModel {
    
    private let bag             = DisposeBag()
    private let network         = NetworkService.shared
    private let userDefault     = UserDefaultService.shared
    private let dataManager     = TestDataManager002.shared
    
    let isLoaded                = BehaviorSubject<Bool>(value: true)
    let cartsDatabaseSubject    = PublishRelay<[CartDatabaseProtocol]>()
    
    func setup() {
        loadData()
    }

    func loadData() {

        network.subscribeOnCartKeys()
            .subscribe(onNext: { [unowned self] cartKeys in
                self.isLoaded.onNext(true)
                self.network.requestCarts(forKeys: cartKeys)
                    .subscribe(onNext: { self.cartsDatabaseSubject.accept($0) })
                    .disposed(by: self.bag)
            }).disposed(by: bag)
    }
    
    func pickCart(_ cart: CartDatabaseProtocol) {
        dataManager.resubscribeOnCart(withNewCart: cart)
    }
}
