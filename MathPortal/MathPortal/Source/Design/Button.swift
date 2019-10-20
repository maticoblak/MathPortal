//
//  Button.swift
//  MathPortal
//
//  Created by Petra Čačkov on 07/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    enum FunctionType: String {
        case next
        case back
        case custom
    }
    
    var type: FunctionType = .custom {
        didSet {
            setupButton()
        }
    }
    
    @IBInspectable var color: UIColor? = Color.pink {
        didSet {
            setupButton()
        }
    }
    
    @IBInspectable var stringType: String {
        get {
            return self.type.rawValue
        }
        set {
            self.type = FunctionType(rawValue: newValue.lowercased()) ?? .next
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    convenience init(type: FunctionType) {
        self.init()
        self.type = type
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        switch type {
        case .next:
            setupAsNextButton()
        case .back:
            setupAsBackButton()
        case .custom:
            setupAsCustom()
        }
    }
    
    private func setupAsNextButton() {
        let image = R.image.nextArrow()
        self.setBackgroundImage(image, for: .normal)
        self.tintColor = Color.lightGrey
    }
    private func setupAsBackButton() {
        let image = R.image.backIcon()
        self.setImage(image, for: .normal)
        self.imageView?.tintColor = Color.lightGrey
        
    }
    
    private func setupAsCustom() {
        self.setTitleColor(color, for: .normal)
        self.layer.borderWidth = 1.5
        self.layer.borderColor = color?.cgColor
        self.layoutIfNeeded()
    }
}
