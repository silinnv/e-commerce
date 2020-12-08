//
//  CartListView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CartListView: UIView {
    
    let tableView           = UITableView()
    let createCartButton    = ECButton()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupTableView()
        setupCreateCartButton()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        add(tableView)
    }
    
    private func setupCreateCartButton() {
        createCartButton.setTitle("Создать корзину", for: .normal)
        createCartButton.setTitleColor(.white, for: .normal)
        createCartButton.backgroundColor = .systemIndigo
        createCartButton.layer.cornerRadius = 8
        add(createCartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            createCartButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -18),
            createCartButton.heightAnchor.constraint(equalToConstant: 50),
            createCartButton.widthAnchor.constraint(equalToConstant: 260).priority(500),
            createCartButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            createCartButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
