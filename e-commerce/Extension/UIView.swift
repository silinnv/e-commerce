//
//  UIView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

extension UIView {
    func add(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
}

extension UIView {
    func setupKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        addGestureRecognizer(tap)
    }
    
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
}

extension UIView {
    func addGradient() {
        let grad = CAGradientLayer()
        let whiteColor = backgroundColor ?? UIColor.white
        let widthSize = max(frame.width, frame.height)
        let gradView = UIView()
        
        grad.colors = [whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(0.0).cgColor]
        grad.locations = [0.0, 1.0]
        grad.frame = CGRect(x: 0, y: 0, width: widthSize, height: 12)
        
        gradView.layer.addSublayer(grad)
        gradView.backgroundColor = .clear
        add(gradView)
        
        NSLayoutConstraint.activate([
            gradView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            gradView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}
