//
//  CartHeaderTableView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CartHeaderTableView: UIView {
    
    let pickerCartButton    = ECButton()
    let settingButton       = ECButton()
    let userSettingButton   = ECButton()
    let titleLabel          = UILabel()
    let userCountLabel      = UILabel()
    let myPriceLabel        = UILabel()
    let fullPriceLabel      = UILabel()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupPickerCartButton()
        setupButton(settingButton, withImage: "slider.horizontal.3")
        setupButton(userSettingButton, withImage: "person")
        setupTitle()
        setupLabel(userCountLabel)
        setupLabel(fullPriceLabel)
        setupMyPriceLabel()
        setupConstraints()
        setDefaultValue()
    }
    
    private func setupLabel(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        addSubview(label)
    }
    
    private func setupButton(_ button: UIButton, withImage imageName: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: imageName)
        button.setImage(image, for: .normal)
        addSubview(button)
    }
    
    private func setupTitle() {
        setupLabel(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.numberOfLines = 0
    }
    
    private func setupMyPriceLabel() {
        setupLabel(myPriceLabel)
        myPriceLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func setupPickerCartButton() {
        pickerCartButton.translatesAutoresizingMaskIntoConstraints = false
        pickerCartButton.setTitleColor(.link, for: .normal)
        pickerCartButton.setTitle("Все корзины", for: .normal)
        addSubview(pickerCartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pickerCartButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            pickerCartButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            pickerCartButton.heightAnchor.constraint(equalToConstant: 30),
            
            userSettingButton.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            userSettingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userSettingButton.heightAnchor.constraint(equalToConstant: 34),
            userSettingButton.widthAnchor.constraint(equalToConstant: 34),
            
            settingButton.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            settingButton.trailingAnchor.constraint(equalTo: userSettingButton.leadingAnchor, constant: -8),
            settingButton.heightAnchor.constraint(equalToConstant: 34),
            settingButton.widthAnchor.constraint(equalToConstant: 34),
                        
            titleLabel.topAnchor.constraint(equalTo: pickerCartButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            
            userCountLabel.bottomAnchor.constraint(equalTo: myPriceLabel.bottomAnchor, constant: -1),
            userCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18),
            
            fullPriceLabel.bottomAnchor.constraint(equalTo: myPriceLabel.bottomAnchor, constant: -1),
            fullPriceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            myPriceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            myPriceLabel.trailingAnchor.constraint(equalTo: fullPriceLabel.leadingAnchor, constant: -3)
        ])
    }
    
    private func setDefaultValue() {
        titleLabel.text = "T"
        userCountLabel.text = " "
        myPriceLabel.text = " "
        fullPriceLabel.text = " "
    }
    
}
