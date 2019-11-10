//
//  KeyboardButton.swift
//  MathPortal
//
//  Created by Petra Čačkov on 27/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    
    var contentType: Button.ButtonType? {
        didSet {
            setup()
        }
    }
    private var buttonView: UIView?
    private var contentView: UIView = UIView()

    
    init(type: Button.ButtonType) {
        super.init(frame: .zero)
        self.contentType = type
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.removeFromSuperview()
        buttonView?.removeFromSuperview()
        self.buttonView = contentType?.componentView
        
        guard let buttonView = buttonView else { return }
        buttonView.isUserInteractionEnabled = false
        
        contentView.layer.cornerRadius = 5
        contentView.isUserInteractionEnabled = false
        contentView.backgroundColor = Color.lightGrey
        
        self.addSubview(contentView)
        addConstraints(parenView: self, childView: contentView)
        
        contentView.addSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0))
        self.backgroundColor = .clear
    }
    
    private func addConstraints(parenView: UIView, childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal, toItem: parenView, attribute: .leading, multiplier: 1.0, constant: 0))
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .trailing, relatedBy: .equal, toItem: parenView, attribute: .trailing, multiplier: 1.0, constant: 0))
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parenView, attribute: .top, multiplier: 1.0, constant: 0))
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: parenView, attribute: .bottom, multiplier: 1.0, constant: 0))
    }

}
