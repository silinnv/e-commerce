//
//  CatalogViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/5/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift

class CatalogViewController: UIViewController {

    private let network = NetworkService.shared
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        label.frame = view.frame
        view.addSubview(label)
        
        network
    }

}
