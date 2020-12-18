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
    let testVM              = CartViewModel2()
    
    let bag                 = DisposeBag()
    let userDefault         = UserDefaultService.shared
    
    var cartData:           CartControllerData!
    var dataSource:         RxTableViewSectionedReloadDataSource<SectionModel<HeaderSectionProductsData, ProductDataSource>>!
    
    override func loadView() {
        view = cartView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindingView()
        setupTableView()
        subscribeOnViewModel()
        testVM.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupBindingView() {
        
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
    
    func setupTableView() {
        cartView.tableView.estimatedRowHeight = 500
        cartView.tableView.rowHeight = UITableView.automaticDimension
        
        cartView.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<HeaderSectionProductsData, ProductDataSource>>(
            configureCell: { (dataSource, tableView, indexPath, item) in

//                let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
                let cell = ProductTableViewCell()
                
                cell.stepper
                    .valueSubject
                    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] newValue in
                        self?.testVM.changeProductCount(product: item, count: newValue)
                    }).disposed(by: cell.bag)
                cell.setup(data: item)
                cell.selectionStyle = .none
                return cell
        })
        
        cartView.tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    func subscribeOnViewModel() {
        
        testVM
            .productData.bind(to: cartView
                .tableView
                .rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        testVM
            .cartControllerData
            .bind { [unowned self] cartData in
                self.cartData = cartData
                self.cartView.updateView(withData: cartData)
            }
            .disposed(by: bag)
    }
    
    private func showCartList(onFullScrean fullScrean: Bool = false) {
        let cartListViewConstroller = CartListViewController()
        
        let nc = UINavigationController()
        nc.viewControllers.append(cartListViewConstroller)
        if fullScrean {
            cartListViewConstroller.modalPresentationStyle = .fullScreen
        }
        cartListViewConstroller.modalTransitionStyle = .coverVertical
        self.navigationController?.showDetailViewController(nc, sender: nil)
    }

}

extension CartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource[section].model
        if cartData.cartType == .privates {
            return UIView()
        }
        let headerView = CartSectionHeaderView(data: model)
        return headerView
    }
}
