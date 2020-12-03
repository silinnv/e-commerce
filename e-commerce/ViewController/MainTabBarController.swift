//
//  MainTabBarController.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/2/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationCatalogController = UINavigationController()
        let catalogViewController = SecondVC()
        let catalogIcon = UITabBarItem(
            title: "Продукты",
            image: UIImage(systemName: "tray.full"),
            selectedImage: UIImage(systemName: "tray.full"))
        navigationCatalogController.viewControllers = [catalogViewController]
        navigationCatalogController.tabBarItem = catalogIcon
        
        let navigationCartController = UINavigationController()
        let cartViewController = CartViewController()
        let cartIcon = UITabBarItem(
            title: " Корзина",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart"))
        navigationCartController.viewControllers = [cartViewController]
        navigationCartController.tabBarItem = cartIcon
        
        let controllers = [navigationCatalogController, navigationCartController]
        self.viewControllers = controllers
    }
}
