//
//  SubCategoryView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class SubCategoryView: UIView {
    
    let tableView   = UITableView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        add(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
