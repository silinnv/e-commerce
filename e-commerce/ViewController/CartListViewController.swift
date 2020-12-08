//
//  CartListViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartListViewController: UIViewController {

    private let cartListView    = CartListView()
    private let viewModel       = CartListViewModel()
    private let bag             = DisposeBag()
    
    override func loadView() {
        view = cartListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    @objc
    func addTapped(_ sender: UIBarButtonItem) {
        dismissViewController()
    }

    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Корзины"
        
        let back = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItems = [back]
        
        cartListView
            .tableView
            .rx
            .modelSelected(CartDatabaseProtocol.self).bind { [unowned self] cart in
                self.viewModel.pickCart(cart)
                self.dismissViewController()
            }.disposed(by: bag)
    }

    private func setupViewModel() {

        viewModel.setup()
        
        cartListView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        viewModel
            .cartsDatabaseSubject
            .bind(to:
                cartListView
                .tableView.rx.items(
                    cellIdentifier: "DefaultCell",
                    cellType: UITableViewCell.self)) { (row, model, cell) in
                        cell.textLabel?.text = model.name
                        cell.selectionStyle = .none
            }.disposed(by: bag)
        
        viewModel.isLoaded.bind { _ in //[unowned self] isLoaded in
            
        }.disposed(by: bag)
    }
    
    private func dismissViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
