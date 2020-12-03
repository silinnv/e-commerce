//
//  LoginView.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class LoginView: UIView {

    let emailTextField      = UITextField()
    let passwordTextField   = UITextField()
    let errorMessageLabel   = UILabel()
    let loginButton         = ECButton()
    let registrationButton  = ECButton()
    let loader              = UIActivityIndicatorView(style: .medium)
    
    private let titleLabel  = UILabel()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .systemIndigo
        setupTitle()
        setupEmailTextField()
        setupPasswordTextField()
        setupErrorMessage()
        setupLoginButton()
        setupRegistrationButton()
        setupConstraints()
        setupKeyboard()
    }
    
    private func setupTitle() {
        titleLabel.text = "m@rket"
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = .white
        add(titleLabel)
    }
    
    private func setupEmailTextField() {
        emailTextField.placeholder = "email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.backgroundColor = .white
        emailTextField.borderStyle = .roundedRect
        add(emailTextField)
    }
    
    private func setupPasswordTextField() {
        passwordTextField.placeholder = "пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .roundedRect
        add(passwordTextField)
    }
    
    private func setupErrorMessage() {
        errorMessageLabel.text = " "
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.font = UIFont.systemFont(ofSize: 16)
        errorMessageLabel.textColor = .white
        add(errorMessageLabel)
    }
    
    private func setupLoginButton() {
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loader.color = .black
        loginButton.add(loader)
        loginButton.backgroundColor = .systemYellow
        loginButton.layer.cornerRadius = 8
        add(loginButton)
    }
    
    private func setupRegistrationButton() {
        registrationButton.setTitle("Зарегистрироваться", for: .normal)
        registrationButton.setTitleColor(.white, for: .normal)
        registrationButton.backgroundColor = .clear
        add(registrationButton)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 56),
            emailTextField.widthAnchor.constraint(equalToConstant: 260).priority(500),
            emailTextField.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            errorMessageLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 18),
            errorMessageLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            errorMessageLabel.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            
            loader.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            loader.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor, constant: 16),
            
            loginButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 36),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            registrationButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 12),
            registrationButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor),
            registrationButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor),
            registrationButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
