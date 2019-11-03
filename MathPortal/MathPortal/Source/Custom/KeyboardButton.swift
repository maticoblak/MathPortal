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
        buttonView.isUserInteractionEnabled = false
        
        let view = UIView()
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = false
        self.insertSubview(view, at: 0)
        buttonView.backgroundColor = .green
        addConstraints(parenView: self, childView: view)
        
        view.addSubview(buttonView)
        view.backgroundColor = .blue
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        self.backgroundColor = .yellow
        
    }
    
    private func addConstraints(parenView: UIView, childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal, toItem: parenView, attribute: .leading, multiplier: 1.0, constant: 0))
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .trailing, relatedBy: .equal, toItem: parenView, attribute: .trailing, multiplier: 1.0, constant: 0))
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parenView, attribute: .top, multiplier: 1.0, constant: 0))
        parenView.addConstraint(NSLayoutConstraint(item: childView, attribute: .bottom, relatedBy: .equal, toItem: parenView, attribute: .bottom, multiplier: 1.0, constant: 0))
    }

}
