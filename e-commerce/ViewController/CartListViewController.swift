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

    public let viewModel            = CartListViewModel()
    public let cartPick             = PublishSubject<CartDataSource>()
    private let cartListView        = CartListView()
    private let bag                 = DisposeBag()
    
    override func loadView() {
        view = cartListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }

    private func setupView() {
        cartListView
            .tableView
            .rx
            .modelSelected(CartDataSource.self).bind { [unowned self] cart in
                self.cartPick.onNext(cart)
                self.cartPick.onCompleted()
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }.disposed(by: bag)
    }

    private func setupViewModel() {

        viewModel.setup()
        
        cartListView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        viewModel
            .cartsDataSubject
            .bind(to: cartListView
                .tableView
                .rx
                .items(
                    cellIdentifier: "DefaultCell",
                    cellType: UITableViewCell.self)) { (row, model, cell) in
                        cell.textLabel?.text = model.name
                        cell.selectionStyle = .none
            }.disposed(by: bag)
        
        viewModel.isLoaded.bind { [unowned self] isLoaded in
            self.cartListView.backgroundColor = isLoaded ? .systemYellow : . systemPurple
        }.disposed(by: bag)
    }
}
