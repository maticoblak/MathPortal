//
//  CustomKeyboardCollectionViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 19/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class CustomKeyboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var keyboardKeyLabel: UILabel?
    @IBOutlet private var keyboardCellView: UIView?
    
    private var buttonView: UIView?
    
    func setKey(key: Button.ButtonType) {
        switch key {
        case .back, .brackets, .delete, .done, .exponent, .forward, .fraction, .index, .root, .plus, .minus, .logarithm, .levelOut, .levelIn, .integer, .letter, .indexAndExponent, .multiplication, .division, .comma, .equal:
            guard let newView = key.componentView else { return }
            guard let cellView = keyboardCellView else { return }
            newView.center = CGPoint(x: cellView.frame.width / 2, y: cellView.frame.height / 2)
            addButtonView(newView)
        case .indicator:
            //keyboardKeyLabel?.text = key.string
            return
        }
        
    }
    
    private func addButtonView(_ view: UIView) {
        if let buttonView = buttonView { buttonView.removeFromSuperview() }
        keyboardCellView?.addSubview(view)
        buttonView = view
    }
    
}
