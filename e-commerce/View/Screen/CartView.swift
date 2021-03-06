//
//  CartView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CartView: UIView {
    
    let tableView           = UITableView()
    let headerView          = CartHeaderTableView()
    
    let cartPickerButton:   UIButton!
    let cartSettingButton:  UIButton!
    let userSettingButton:  UIButton!
    
    init(isCompactMode: Bool = false) {
        cartPickerButton = headerView.pickerCartButton
        cartSettingButton = headerView.settingButton
        userSettingButton = headerView.userSettingButton
        super.init(frame: .zero)
        backgroundColor = .white
        commonInit(isCompactMode: isCompactMode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(isCompactMode: Bool) {
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        add(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.topAnchor.constraint(equalTo: tableView.topAnchor)
        ])
    }
    
}

extension CartView {
    
    func updateView(with cart: CartDataSource) {
        headerView.updateView(with: cart)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateView(withData cart: CartControllerData) {
        headerView.updateView(withData: cart)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
