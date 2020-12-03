//
//  CartListViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CartListViewController: UIViewController {

    
    override func loadView() {
        let cartListView = CartListView()
        view = cartListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
