//
//  LoginNavigationController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class LoginNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginViewController = LoginViewController()
        viewControllers = [loginViewController]
    }
}
