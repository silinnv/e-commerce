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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.alpha = 0.5
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
    
    func setupPickerButton() {
        add(pickerCartButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerCartButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            pickerCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pickerCartButton.heightAnchor.constraint(equalToConstant: 30),
            
            userSettingButton.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            userSettingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userSettingButton.heightAnchor.constraint(equalToConstant: 34),
            userSettingButton.widthAnchor.constraint(equalToConstant: 34),
            
            titleLabel.topAnchor.constraint(equalTo: pickerCartButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            
            cartNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            cartNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            cartNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            cartNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            
        ])
    }
}

class CatalogView: UIView {
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    let header = HV()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        setupTableView()
        addGrad()
    }
    
    private func setupTableView() {
        
        let headerView = header
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layoutIfNeeded()
        
        tableView.tableHeaderView = headerView
        
        tableView.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            headerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func addGrad() {
        
        let grad = CAGradientLayer()
        let whiteColor = UIColor.white
        let gradView = UIView()
        grad.colors = [whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(0.0).cgColor]
        grad.locations = [0.0, 1.0]

        grad.frame = CGRect(x: 0, y: 0, width: 500, height: 12)
        gradView.layer.addSublayer(grad)
        add(gradView)

        NSLayoutConstraint.activate([
            gradView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            gradView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
