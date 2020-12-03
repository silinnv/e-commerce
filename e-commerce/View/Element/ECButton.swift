//
//  ECButton.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/3/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//

import UIKit

class ECButton: UIButton {

    init() {
        super.init(frame: .zero)
        addTarget(nil, action: #selector(touchDown), for: .touchDown)
        addTarget(nil, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside])
    }

    @objc
    private func touchDown(_ sender: ECButton) {
        self.titleLabel?.alpha = 0.3
        self.imageView?.alpha = 0.3
    }

    @objc
    private func touchUp(_ sender: ECButton) {
        UIView.animate(withDuration: 0.25) {
            self.titleLabel?.alpha = 1
            self.imageView?.alpha = 1
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
