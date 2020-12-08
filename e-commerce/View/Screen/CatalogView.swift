//
//  CatalogView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/7/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class HV: UIView {
    
    let pickerCartButton: ECButton = {
        let button = ECButton()
        button.setTitle("Все корзины", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Каталог"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    let cartNameLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.alpha = 0.75
        return label
    }()
    
    let userSettingButton: ECButton = {
        let button = ECButton()
        let image = UIImage(systemName: "person")
        button.setImage(image, for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        add(pickerCartButton)
        add(userSettingButton)
        add(titleLabel)
        add(cartNameLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerCartButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            pickerCartButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pickerCartButton.heightAnchor.constraint(equalToConstant: 30),
            
            userSettingButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 6),
            userSettingButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            userSettingButton.heightAnchor.constraint(equalToConstant: 34),
            userSettingButton.widthAnchor.constraint(equalToConstant: 34),
            
            titleLabel.topAnchor.constraint(equalTo: pickerCartButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            
            cartNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            cartNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cartNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cartNameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
            
        ])
    }
}

class CatalogView: UIView {
    
    let tableView   = UITableView()
    let header      = HV()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.layoutIfNeeded()
        tableView.tableHeaderView = header
        add(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            header.topAnchor.constraint(equalTo: tableView.topAnchor),
            header.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
