//
//  LoginViewModel.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private let network = NetworkService()
    private let userDefaults = UserDefaultService.shared
    
    private let errorMessage = "Неверный email или пароль"
    
    let isLoaded = BehaviorSubject<Bool>(value: false)
    let isPasswordConfirmSubject = PublishSubject<Bool>()
    let errorMessageSubject = BehaviorRelay<String>(value: "")
    
    func trySingIn(email: String, password: String) {
        isLoaded.onNext(true)
        network.singIn(email: email, password: password) { [unowned self] result in
            self.isLoaded.onNext(false)
            switch result {
            case .success(let userID):
                self.isPasswordConfirmSubject.onNext(true)
                self.userDefaults.currentUserID = userID
                self.userDefaults.isUserLogin = true
                self.errorMessageSubject.accept(" ")
            case .failure(_):
                self.errorMessageSubject.accept(self.errorMessage)
                self.isPasswordConfirmSubject.onNext(false)
            }
        }
    }

}
