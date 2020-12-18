//
//  TestCell.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/8/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductTableViewCell: UITableViewCell {
    
    static let identifier: String = "TestID"
    
    let bag = DisposeBag()
    
    let images: CustomImageView = {
        let image = UIImage(systemName: "cube")
        let imageView = CustomImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.3
        imageView.tintColor = .black
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.alpha = 0.6
        return label
    }()
    
    let dotLabel: UILabel = {
        let label = UILabel()
        label.text = "•"
        label.font = UIFont.systemFont(ofSize: 12)
        label.alpha = 0.6
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.alpha = 0.6
        return label
    }()
    
    let allPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.alpha = 0.6
        return label
    }()
    
    let myPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    var stepper: Stepper = Stepper()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        add(images)
        add(nameLabel)
        add(priceLabel)
        add(dotLabel)
        add(weightLabel)
        add(allPriceLabel)
        add(myPriceLabel)
        add(stepper)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            images.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            images.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            images.heightAnchor.constraint(equalToConstant: 64),
            images.widthAnchor.constraint(equalTo: images.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: images.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: images.trailingAnchor, constant: 10),
            
            dotLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            dotLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 6),
            
            weightLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            weightLabel.leadingAnchor.constraint(equalTo: dotLabel.trailingAnchor, constant: 6),
            
            allPriceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            allPriceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            myPriceLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            myPriceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            myPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            stepper.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            stepper.leadingAnchor.constraint(equalTo: images.trailingAnchor, constant: 10),
            stepper.heightAnchor.constraint(equalToConstant: 24),
            stepper.widthAnchor.constraint(equalToConstant: 70),
            stepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }
    
    func setup(data: ProductDataSource) {
        nameLabel.text = data.name
        priceLabel.text = data.price.priceFormat()
        weightLabel.text = String(format: "%.0lf г", data.weight)
        stepper.value = data.myCount
        stepper.stepperState = data.myCount == 0 ? .initial: .normal
        allPriceLabel.text = data.allPrice.priceFormat()
        myPriceLabel.text = data.myPrice.priceFormat()
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let imageURL = data.imageURL {
                self?.images.loadImage(url: imageURL) {
                    self?.images.alpha = 1
                }
            }
        }
    }
    
    override func prepareForReuse() {
        stepper.valueSubject = PublishSubject<Double>()
    }

}
