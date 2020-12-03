//
//  HeaderTableView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class HeaderTableView: UIView {

    let pickerCartButton    = UIButton()
    let userSettingButton   = UIButton()
    let titleLabel          = UILabel()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupPickerCartButton()
        setupButton(userSettingButton, withImage: "person")
        setupTitle(titleLabel)
        setupConstraints()
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
        button.backgroundColor = UIColor(red: 0.75, green: 0.90, blue: 0.98, alpha: 1)
        button.layer.cornerRadius = 18
        addSubview(button)
    }
    
    private func setupTitle(_ label: UILabel) {
        setupLabel(label)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
    }
    
    private func setupPickerCartButton() {
        pickerCartButton.translatesAutoresizingMaskIntoConstraints = false
        pickerCartButton.setTitleColor(.link, for: .normal)
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
                        
            titleLabel.topAnchor.constraint(equalTo: pickerCartButton.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

}
