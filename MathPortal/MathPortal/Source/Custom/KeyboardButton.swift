//
//  KeyboardButton.swift
//  MathPortal
//
//  Created by Petra Čačkov on 27/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class KeyboardButton: UIButton {
    
    var contentType: Button.ButtonType?
    var buttonView: UIView?

    
    init(type: Button.ButtonType) {
        super.init(frame: .zero)
        self.contentType = type
        self.buttonView = type.componentView
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        guard let buttonView = buttonView else { return }
        self.addSubview(buttonView)
        buttonView.backgroundColor = .blue
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        self.backgroundColor = .clear
        
    }
    

}
