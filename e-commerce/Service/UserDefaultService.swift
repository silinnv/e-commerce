//
//  UserDefaultService.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation

final class UserDefaultService {

    enum UDKeys: String {
        case currentUserID = "userID"
        case currentCartID = "cartID"
        case isUserLogin   = "isUserLogin"
    }

    static var shared: UserDefaultService = {
        UserDefaultService()
    }()

    private init () {}

    private let userDefault = UserDefaults.standard

    public var currentUserID: String {
        get { userDefault.string(forKey: UDKeys.currentUserID.rawValue) ?? "" }
        set { userDefault.set(newValue, forKey: UDKeys.currentUserID.rawValue) }
    }

    public var currentCartID: String {
        get { userDefault.string(forKey: UDKeys.currentCartID.rawValue) ?? "" }
        set { userDefault.set(newValue, forKey: UDKeys.currentCartID.rawValue) }
    }
    
    public var isUserLogin: Bool {
        get { userDefault.bool(forKey: UDKeys.isUserLogin.rawValue) }
        set { userDefault.set(newValue, forKey: UDKeys.isUserLogin.rawValue) }
    }
}
