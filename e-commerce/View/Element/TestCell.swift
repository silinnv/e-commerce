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

class CustomTableViewCell: UITableViewCell {
    
    static let id: String = "TestID"

    let imgUser: UIImageView = {
        let image = UIImage(systemName: "play")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    let labUerName: UILabel = {
        let label = UILabel()
        label.text = "user"
        return label
    }()
    let labMessage: UILabel = {
        let label = UILabel()
        label.text = "message"
        return label
    }()
    let labTime: UILabel = {
        let label = UILabel()
        label.text = "time"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imgUser.backgroundColor = UIColor.blue

        imgUser.translatesAutoresizingMaskIntoConstraints = false
        labUerName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        labTime.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(imgUser)
        contentView.addSubview(labUerName)
        contentView.addSubview(labMessage)
        contentView.addSubview(labTime)

        let viewsDict = [
            "image" : imgUser,
            "username" : labUerName,
            "message" : labMessage,
            "labTime" : labTime,
            ] as [String : Any]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(10)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[labTime]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[username]-[message]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[username]-[image(10)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[message]-[labTime]-|", options: [], metrics: nil, views: viewsDict))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ProductTableViewCell: UITableViewCell {
    
    static let identifier: String = "TestID"
    
    let bag = DisposeBag()
    
    var images: UIImageView = {
        let image = UIImage(systemName: "cart")
        let imageView = UIImageView(image: image)
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
    
    let stepper: Stepper = Stepper()

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

//        imgUser.backgroundColor = UIColor.blue
//
//        imgUser.translatesAutoresizingMaskIntoConstraints = false
//        labUerName.translatesAutoresizingMaskIntoConstraints = false
//        labMessage.translatesAutoresizingMaskIntoConstraints = false
//        labTime.translatesAutoresizingMaskIntoConstraints = false
//
//        contentView.addSubview(imgUser)
//        contentView.addSubview(labUerName)
//        contentView.addSubview(labMessage)
//        contentView.addSubview(labTime)
//
//        let viewsDict = [
//            "image" : imgUser,
//            "username" : labUerName,
//            "message" : labMessage,
//            "labTime" : labTime,
//            ] as [String : Any]
//
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(10)]", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[labTime]-|", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[username]-[message]-|", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[username]-[image(10)]-|", options: [], metrics: nil, views: viewsDict))
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[message]-[labTime]-|", options: [], metrics: nil, views: viewsDict))
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
//            images.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor, constant: 10),
            
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: images.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: images.trailingAnchor, constant: 10),
//            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
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
            stepper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func updateImage(_ image: UIImage?) {
        images = UIImageView(image: image)
    }

}
