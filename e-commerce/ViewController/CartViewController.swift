//
//  CartViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {
    
    let bag = DisposeBag()
    
    var cartView = CartView()
    var tableView: UITableView!
    var button: UIButton!
    var cartSettingButton: UIButton!
    var userSettingButton: UIButton!
    
    override func loadView() {
        view = cartView
        tableView = cartView.tableView
        button = cartView.cartPickerButton
        cartSettingButton = cartView.cartSettingButton
        userSettingButton = cartView.userSettingButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupTableView() {
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        let data = Observable<[Int]>.just([1,2,3])
        
        data.bind(to: tableView.rx.items(cellIdentifier: "DefaultCell", cellType: UITableViewCell.self)) { a, b, c in
            c.textLabel?.text = "\(b)"
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Int.self).subscribe(onNext: { nbr in
            print(nbr)
        }).disposed(by: bag)
        
//        button.rx.tap.bind { [unowned self] in
//            let vc = CartListViewController()
//            self.navigationController?.showDetailViewController(vc, sender: nil)
//        }.disposed(by: bag)
        
        userSettingButton.rx.tap.bind {
            print("user button")
            let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: bag)
        cartSettingButton.rx.tap.bind { print("cart button") }.disposed(by: bag)
    }
}
