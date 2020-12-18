//
//  SubCategoryViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SubCategoryViewController: UIViewController {

    let subCategoryView = SubCategoryView()
    let viewModel       = SubCategoryViewModel()
    var tableView       : UITableView!
    
    private let bag     = DisposeBag()
    
    override func loadView() {
        view = subCategoryView
        tableView = subCategoryView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        viewModel.requestProducts()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        viewModel
            .productSubject
            .bind(to: tableView.rx.items(cellIdentifier: ProductTableViewCell.identifier, cellType: ProductTableViewCell.self)) { row, model, cell in
                cell.setup(data: model)
                cell.selectionStyle = .none
                cell.allPriceLabel.isHidden = true
                
                UIView.animate(withDuration: 0.12) {
                    cell.myPriceLabel.alpha = (model.myCount == .zero) ? 0 : 1
                }
                
                cell.stepper
                    .valueSubject
                    .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] newValue in
                        guard self != nil else { return }
                        self!.viewModel.changeProductCountInNetwork(product: model, count: newValue)
                    }).disposed(by: cell.bag)
                
                cell.stepper
                    .valueSubject.subscribe(onNext: { [weak self] newValue in
                        guard self != nil else { return }
                        self!.viewModel.changeProductCountOnUI(updatedProduct: model, newMyCount: newValue)
                    }).disposed(by: cell.bag)
                
                
            }.disposed(by: bag)
    }
}

extension SubCategoryViewController: UITableViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.isFetchingMore else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            viewModel.requestProducts()
        }
    }
}
