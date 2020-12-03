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
    
    var cartView            = CartView()
    let bag                 = DisposeBag()
    let userDefault         = UserDefaultService.shared
    
    var tableView:          UITableView!
    var cartPickerbutton:   UIButton!
    var cartSettingButton:  UIButton!
    var userSettingButton:  UIButton!
    
    override func loadView() {
        view                = cartView
        tableView           = cartView.tableView
        cartPickerbutton    = cartView.cartPickerButton
        cartSettingButton   = cartView.cartSettingButton
        userSettingButton   = cartView.userSettingButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
                
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
//
//        let data = Observable<[Int]>.just([1,2,3])
//
//        data.bind(to: tableView.rx.items(cellIdentifier: "DefaultCell", cellType: UITableViewCell.self)) { a, b, c in
//            c.textLabel?.text = "\(b)"
//        }.disposed(by: bag)
//
//        tableView.rx.modelSelected(Int.self).subscribe(onNext: { nbr in
//            print(nbr)
//        }).disposed(by: bag)
        
        cartPickerbutton.rx.tap.bind { [unowned self] in
            self.showCartList()
        }.disposed(by: bag)
        
        userSettingButton.rx.tap.bind { print("user button") }.disposed(by: bag)
        
        cartSettingButton.rx.tap.bind { print("cart button") }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if userDefault.currentCartID.isEmpty {
            self.showCartList(onFullScrean: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func showCartList(onFullScrean fullScrean: Bool = false) {
        let cartListViewConstroller = CartListViewController()
        if fullScrean {
            cartListViewConstroller.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.showDetailViewController(cartListViewConstroller, sender: nil)
    }

}
