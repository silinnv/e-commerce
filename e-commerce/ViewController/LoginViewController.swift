//
//  LoginViewController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    private let loginView           = LoginView()
    private let viewModel           = LoginViewModel()
    private let bag                 = DisposeBag()
    
    private var emailTextField:     UITextField!
    private var passwordTextField:  UITextField!
    private var errorMessageLabel:  UILabel!
    private var loginButton:        ECButton!
    private var registrationButton: ECButton!
    private var loader:             UIActivityIndicatorView!
    
    override func loadView() {
        view                        = loginView
        emailTextField              = loginView.emailTextField
        passwordTextField           = loginView.passwordTextField
        errorMessageLabel           = loginView.errorMessageLabel
        loginButton                 = loginView.loginButton
        registrationButton          = loginView.registrationButton
        loader                      = loginView.loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
    }
    
    private func setupView() {
        
        loginButton
            .rx
            .tap
            .bind { [unowned self] in
                let email = self.emailTextField.text ?? ""
                let password = self.passwordTextField.text ?? ""
                self.viewModel.trySingIn(email: email, password: password)
            }.disposed(by: bag)
    }
    
    private func setupViewModel() {
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        
        viewModel
            .isLoaded
            .bind { [unowned self] isLoaded in
                self.loader.isHidden = !isLoaded
                isLoaded ? self.loader.startAnimating() : self.loader.stopAnimating()
            }.disposed(by: bag)
        
        viewModel
            .errorMessageSubject
            .bind { [unowned self] errorMessage in
                self.errorMessageLabel.text = errorMessage
            }.disposed(by: bag)
        
        viewModel
            .isPasswordConfirmSubject
            .bind { [unowned self] isConfirm in
                if !isConfirm {
                    self.passwordTextField.text = ""
                } else {
                    guard let scene = sceneDelegate else { return }
                    let viewController = MainTabBarController()
                    scene.setRootViewController(newViewController: viewController)
                }
            }.disposed(by: bag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
