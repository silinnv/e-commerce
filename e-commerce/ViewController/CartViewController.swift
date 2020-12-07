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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
            .cartDataSubject
            .bind { [unowned self] cart in
                self.cartView.updateView(with: cart)
            }.disposed(by: bag)
        
        cartView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, ProductDataSource>>(
            configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = "\(item.myPrice) \(item.allPrice) " + item.name
                return cell
        },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].model
        })
        
        viewModel.productData.bind(to: self.cartView.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }
    
    private func showCartList(onFullScrean fullScrean: Bool = false) {
        let cartListViewConstroller = CartListViewController()
        if fullScrean {
            cartListViewConstroller.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.showDetailViewController(cartListViewConstroller, sender: nil)
    }

}
