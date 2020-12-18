//
//  CartSectionHeaderView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/8/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CartSectionHeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    init(data: HeaderViewModel) {
        super.init(frame: .zero)
        titleLabel.text = data.title
        priceLabel.text = data.price
        commonInit()
    }
    
    init(data: HeaderSectionProductsData) {
        super.init(frame: .zero)
        titleLabel.text = data.title
        priceLabel.text = data.myPrice + " " + data.allProce
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .white
        addBG()
        add(titleLabel)
        add(priceLabel)
        setupLayoutConstraints()
    }
    
    private func addLine() {
        let line = UIView()
        line.backgroundColor = .systemGray2
        add(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addBG() {
        let bg = UIView()
        bg.backgroundColor = .systemOrange
        bg.alpha = 0.2
        bg.layer.cornerRadius = 24
        add(bg)
        NSLayoutConstraint.activate([
            bg.heightAnchor.constraint(equalToConstant: 48),
            bg.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            bg.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 4)
        ])
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            priceLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),

            titleLabel.firstBaselineAnchor.constraint(equalTo: priceLabel.firstBaselineAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalToConstant: 175).priority(500)
        ])
    }
}
