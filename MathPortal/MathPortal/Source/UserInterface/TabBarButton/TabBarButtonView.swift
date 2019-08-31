//
//  TabBarButtonView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 10/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TabBarButtonView: CustomView {

    @IBOutlet private var buttonTitle: UILabel?
    @IBOutlet private var button: UIButton?
    

    @IBInspectable var selected: Bool = false {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var text: String? = "Test" {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var selectedColor: UIColor? {
        didSet {
            refresh()
        }
    }
    @IBInspectable var normalColor: UIColor? {
        didSet {
            refresh()
        }
    }
    
    override func setup() {
        super.setup()
        refresh()
    }
    func refresh() {
        buttonTitle?.text = text
        buttonTitle?.textColor = selected ? selectedColor : normalColor
    }
    
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button?.addTarget(target, action: action, for: controlEvents)
    }
}
