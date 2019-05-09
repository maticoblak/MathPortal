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
    
    
    func setKey(key: Button.ButtonType) {
        switch key {
        case .fraction:
            guard let newView = key.fractionView else { return }
            guard let cellView = keyboardCellView else { return }
            newView.center = CGPoint(x: cellView.frame.width / 2, y: cellView.frame.height / 2)
            keyboardCellView?.addSubview(newView)
        default:
            keyboardKeyLabel?.text = key.string
        }
        
    }
}
