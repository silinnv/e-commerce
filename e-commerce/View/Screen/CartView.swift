//
//  CartView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CartView: UIView {
    
    let headerView: CartHeaderTableView = CartHeaderTableView()
    let tableView = UITableView()
    let cartPickerButton: UIButton!
    let cartSettingButton: UIButton!
    let userSettingButton: UIButton!
    
    init(isCompactMode: Bool = false) {
        cartPickerButton = headerView.pickerCartButton
        cartSettingButton = headerView.settingButton
        userSettingButton = headerView.userSettingButton
        super.init(frame: .zero)
        commonInit(isCompactMode: isCompactMode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(isCompactMode: Bool) {
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        addSubview(tableView)
        
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
