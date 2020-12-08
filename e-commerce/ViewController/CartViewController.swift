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
    
    var dataSource:         RxTableViewSectionedReloadDataSource<SectionModel<HeaderViewModel, ProductDataSource>>!
    
    override func loadView() {
        view = cartView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setup()
        setupBindView()
        setupTableView()
        subscribeOnViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupBindView() {
        
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
        
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel<HeaderViewModel, ProductDataSource>>(
            configureCell: { (dataSource, tableView, indexPath, item) in
                let cell = ProductTableViewCell(frame: .zero)
                
                cell.nameLabel.text = item.name
                cell.priceLabel.text = item.price.priceFormat()
                cell.weightLabel.text = item.weight.priceFormat()
                cell.stepper.value = item.myCount
                cell.stepper.stepperState = item.myCount == 0 ? .initial: .normal
                cell.allPriceLabel.text = item.allPrice.priceFormat()
                cell.myPriceLabel.text = item.myPrice.priceFormat()
                
                cell.stepper
                    .valueSubject
                    .distinctUntilChanged()
                    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] newValue in
                        self?.viewModel.changeProductCount(productID: item.ID, count: newValue)
                    }).disposed(by: cell.bag)
                return cell
        })
        
        cartView.tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    func subscribeOnViewModel() {
        viewModel
            .cartDataSubject
            .bind { [unowned self] cart in
                self.cartView.updateView(with: cart)
            }.disposed(by: bag)
        
        viewModel
            .productData
            .bind(to: self.cartView
                .tableView
                .rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func showCartList(onFullScrean fullScrean: Bool = false) {
        let cartListViewConstroller = CartListViewController()
        
        let nc = UINavigationController()
        nc.viewControllers.append(cartListViewConstroller)
        let backItem = UIBarButtonItem()
        backItem.title = "Something Else"
        nc.navigationItem.backBarButtonItem = backItem
        
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
        guard model.cartType != .privates else { return UIView() }
        
        let headerView = CartSectionHeaderView(data: model)
        return headerView
    }
}
