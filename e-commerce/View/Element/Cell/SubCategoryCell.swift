//
//  SubCategoryCell.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/11/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {
    
    static let identifier: String = "SubCategoryTableViewCell"

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        add(nameLabel)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 45),
            nameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    func setup(data: SubCategoty) {
        nameLabel.text = data.name
        if data.style == .bold {
            nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
    }
    
    override func prepareForReuse() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
    }

}
