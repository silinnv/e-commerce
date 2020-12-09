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

    let catalogView = CatalogView()
    let viewModel   = CatalogViewModel()
    let bag         = DisposeBag()
    
    override func loadView() {
        view = catalogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        subscribeOnViewModel()
        
        let ref = Database.database().reference()
        let refTest = ref.child("H1")
        refTest.child("H2_U").removeAllObservers()
        
        refTest.observe(.value) { snap in
            if let data = snap.value as? [String: Any] {
                print(data)
            }
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        catalogView.addGradient()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupView() {
        catalogView.header
            .pickerCartButton
            .rx.tap.bind { [unowned self] in
                self.showCartList()
            }.disposed(by: bag)
    }
    
    func setupTableView() {
        
        catalogView.tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    func subscribeOnViewModel() {
        
        viewModel.cartSubject
            .subscribe(onNext: { [unowned self] cart in
                self.catalogView.header.cartNameLabel.text = cart.name
                DispatchQueue.main.async {
                    self.catalogView.tableView.reloadData()
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

extension CatalogViewController: UITableViewDelegate {
    
}
