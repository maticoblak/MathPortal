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
    
    @IBInspectable var color: UIColor? {
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
            return
        }
    }
    
    private func setupAsNextButton() {
        let image = R.image.nextArrow()
        self.setBackgroundImage(image, for: .normal)
        self.tintColor = UIColor.mathLightGrey
    }
    private func setupAsBackButton() {
        let image = R.image.backIcon()
        self.setImage(image, for: .normal)
        self.imageView?.tintColor = UIColor.mathLightGrey
        
    }
}
