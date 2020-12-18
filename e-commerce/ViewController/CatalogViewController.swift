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
import RxDataSources
import Firebase

class CatalogViewController: UIViewController {

    let catalogView = CatalogView()
    let viewModel   = CatalogViewModel()
    let bag         = DisposeBag()
    
    var catalogData = [Category]()
    
    override func loadView() {
        view = catalogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        subscribeOnViewModel()
        
        test()
        viewModel.setup()
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
    
    func test() {
        catalogView.tableView.dataSource = self
        catalogView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        catalogView.tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        catalogView.tableView.register(SubCategoryTableViewCell.self, forCellReuseIdentifier: SubCategoryTableViewCell.identifier)
        
        viewModel.catalogSubject.subscribe(onNext: { [weak self] categories in
            self?.catalogData = categories
            DispatchQueue.main.async {
                self?.catalogView.tableView.reloadData()
            }
        }).disposed(by: bag)
    }
    
    func setupView() {
        
        navigationItem.title = catalogView.header.titleLabel.text
        
        catalogView.header
            .pickerCartButton
            .rx.tap.bind { [unowned self] in
                self.showCartList()
            }.disposed(by: bag)
        
        catalogView.header
            .userSettingButton
            .rx.tap.bind { [unowned self] in
                self.pushProfileSetting()
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
    
    private func pushSubCategoty(withData data: SubCategoty) {
        let subCategoryViewController = SubCategoryViewController()
        subCategoryViewController.title = data.header
        subCategoryViewController.viewModel.productKeys = data.productKeys
        self.navigationController?.pushViewController(subCategoryViewController, animated: true)
    }
    
    private func pushProfileSetting() {
        let profileSettingViewController = PrifileSettingViewController()
        self.navigationController?.pushViewController(profileSettingViewController, animated: true)
    }
}

extension CatalogViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return catalogData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if catalogData[section].isOpened {
            return catalogData[section].subCategories.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as! CategoryTableViewCell
            cell.setup(data: catalogData[indexPath.section])
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SubCategoryTableViewCell.identifier) as! SubCategoryTableViewCell
            cell.setup(data: catalogData[indexPath.section].subCategories[indexPath.row - 1])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            catalogData[indexPath.section].isOpened = !catalogData[indexPath.section].isOpened
            let section = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(section, with: .none)
        } else {
            let subCategoryData = catalogData[indexPath.section].subCategories[indexPath.row - 1]
            pushSubCategoty(withData: subCategoryData)
        }
    }
    
    
}
