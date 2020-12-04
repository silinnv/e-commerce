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
import RxDataSources

class CartViewController: UIViewController {
    
    let cartView            = CartView()
    let viewModel           = CartViewModel()
    let bag                 = DisposeBag()
    let userDefault         = UserDefaultService.shared
    
    override func loadView() {
        view = cartView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    func setupView() {
        
        cartView
            .cartPickerButton
            .rx.tap.bind { [unowned self] in
                self.showCartList()
            }.disposed(by: bag)
        
        cartView
            .userSettingButton
            .rx.tap.bind {
                print("user button")
            }.disposed(by: bag)
        
        cartView
            .cartSettingButton
            .rx.tap.bind {
                print("cart button")
            }.disposed(by: bag)
    }
    
    func setupViewModel() {
        
        viewModel.setup()
        
        viewModel
            .cartSubject
            .bind { [unowned self] cart in
                self.cartView.updateView(with: cart)
            }.disposed(by: bag)
    }
    
    func loadCart(cartID: String) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: Load cart
        // load first cart
        // if (cart count == 0) -> oper cartList

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
        
        cartListViewConstroller
            .cartPick
            .bind { [unowned self] cart in
                self.viewModel.cartSubject.onNext(cart)
        }.disposed(by: bag)
        
        self.navigationController?.showDetailViewController(cartListViewConstroller, sender: nil)
    }

}
