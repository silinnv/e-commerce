//
//  NetworkService.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class NetworkService {
    
    func singIn(email: String, password: String, _ clouser: @escaping (Result<String, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            guard let user = user, error == nil else {
                clouser(.failure(error!))
                return
            }
            clouser(.success(user.user.uid))
        }
    }
    
}
