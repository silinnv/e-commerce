//
//  Stepper.swift
//  e-commerce
//
//  Created by Fredia Wiley on 12/8/20.
//  Copyright © 2020 Fredia Wiley. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

public enum StepperState {
    case normal
    case initial
}

class Stepper: UIView {
    // MARK: - Properties
    public var stepperState: StepperState = .initial {
        didSet {
            checkStepperState()
            checkEnabledButton()
        }
    }
    
    public var valueSubject = PublishSubject<Double>()
    private let disposeBag = DisposeBag()
    
    public var value: Double = 0 {
        didSet {
            valueLabel.text = showIntValue ? "\(Int(value))" : "\(value)"
        }
    }
    
    public var minValue: Double = 0
    public var maxValue: Double = .infinity
    public var stepValue: Double = 1
    public var showIntValue: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let valueLabel = UILabel(frame: .zero)
    public let increaseButton = UIButton(type: .custom)
    public let decreaseButton = UIButton(type: .custom)
    private let stack = UIStackView(frame: .zero)
    
    private let widthStepper: CGFloat = 70
    private let heightStrpper: CGFloat = 24
    private let animationDuration = 0 //0.16
    
    // MARK: - Init
    public init(initValue: Double = 0.0) {
        super.init(frame: .zero)
        valueSubject
            .subscribe(onNext: { [unowned self] newValue in
                self.valueLabel.text = self.showIntValue ? "\(Int(newValue))" : "\(newValue)"
            }).disposed(by: DisposeBag())
        commonInit(initValue: initValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValue(_ value: Double) {
        valueSubject.onNext(value)
    }
    
    // MARK: - View setup
    private func commonInit(initValue: Double) {
        setupLabel()
        setupButton(decreaseButton, with: "minus")
        decreaseButton.addTarget(nil, action: #selector(decrease(_:)), for: .touchUpInside)
        setupButton(increaseButton, with: "plus")
        increaseButton.addTarget(nil, action: #selector(increase(_:)), for: .touchUpInside)
        setupStack()
        
        stack.addArrangedSubview(decreaseButton)
        stack.addArrangedSubview(valueLabel)
        stack.addArrangedSubview(increaseButton)
        addSubview(stack)
        
        setupConstraints()
        checkStepperState()
        checkEnabledButton()
    }
    
    private func setupLabel() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        valueLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .semibold)
    }
    
    private func setupButton(_ button: UIButton, with imageName: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .darkGray
        let image = UIImage(systemName: imageName)
        let imageView = UIImageView(image: image)
        button.add(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalToConstant: 18)
        ])

    }
    
    private func setupStack() {
        let bgColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        stack.setBackground(color: bgColor, withRadius: 6)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.widthAnchor.constraint(equalToConstant: widthStepper),
            stack.heightAnchor.constraint(equalToConstant: heightStrpper),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Stepping
    @objc private func decrease(_ sender: UIButton) {
        value = max(value - stepValue, minValue)
        if value == minValue {
            stepperState = .initial
        }
        checkEnabledButton()
        valueSubject.onNext(value)
    }
    
    @objc private func increase(_ sender: UIButton) {
        value += stepValue
        if value >= minValue + stepValue {
            stepperState = .normal
        }
        checkEnabledButton()
        valueSubject.onNext(value)
    }
    
    private func checkEnabledButton() {
        decreaseButton.isEnabled = value > minValue
        increaseButton.isEnabled = value + stepValue <= maxValue
    }
    
    private func checkStepperState() {
        switch stepperState {
        case .normal where valueLabel.alpha != 1:
            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                self.increaseButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.decreaseButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.valueLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                self.decreaseButton.alpha = 1
                self.valueLabel.alpha = 1
            }
        case .initial where valueLabel.alpha != 0:
            UIView.animate(withDuration: TimeInterval(animationDuration)) {
                let translationX = -1 * self.widthStepper / 3
                self.increaseButton.transform = CGAffineTransform(translationX: translationX , y: 0)
                self.decreaseButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.valueLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                
                self.decreaseButton.alpha = 0
                self.valueLabel.alpha = 0
            }
        default:
            break
        }
    }
}

extension UIStackView {
    func setBackground(color: UIColor, withRadius radius: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        subView.layer.cornerRadius = radius
    }
}
