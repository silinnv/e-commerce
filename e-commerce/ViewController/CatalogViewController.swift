//
//  CatalogViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/5/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class CatalogViewController: UIViewController {

    let catalogVIew = CatalogView()
    let viewModel   = CatalogViewModel()
    let bag         = DisposeBag()
    
    override func loadView() {
        view = catalogVIew
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView() {
        catalogVIew.header
            .pickerCartButton
            .rx.tap.bind { [unowned self] in
                self.showCartList()
            }.disposed(by: bag)
    }
    
    func setupViewModel() {
        
        viewModel.cartSubject
            .subscribe(onNext: { [unowned self] cart in
                self.catalogVIew.header.cartNameLabel.text = cart.name
                DispatchQueue.main.async {
                    self.catalogVIew.tableView.reloadData()
                }
            }).disposed(by: bag)
    }
    
    private func showCartList(onFullScrean fullScrean: Bool = false) {
        let cartListViewConstroller = CartListViewController()
        if fullScrean {
            cartListViewConstroller.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.showDetailViewController(cartListViewConstroller, sender: nil)
    }
    
    

}
