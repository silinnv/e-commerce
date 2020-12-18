//
//  CategoryCell.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier: String = "CategoryTableViewCell"

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
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        add(images)
        add(nameLabel)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            images.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            images.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            images.heightAnchor.constraint(equalToConstant: 44),
            images.widthAnchor.constraint(equalTo: images.heightAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: images.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    func setup(data: Category) {
        nameLabel.text = data.name

        DispatchQueue.global(qos: .utility).async {
            self.images.loadImage(url: data.imageURL!) {
                self.images.alpha = 1
            }
        }
            
//        dataManager.downloadImage(url: data.imageURL) { [weak self] imageData in
//            DispatchQueue.main.async {
//                let image = UIImage(data: imageData)
//                self?.images.image = image
//                self?.images.alpha = 1
//            }
//        }
    }
    
    override func prepareForReuse() {
        let image    = UIImage(systemName: "cube")
        images.alpha = 0.3
        images.image = image
    }

}
