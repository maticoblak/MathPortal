//
//  CustomKeyboardCollectionViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 19/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class CustomKeyboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var keyboardKeyOutlet: UIButton?
    
    func setKey(name: String) {
        keyboardKeyOutlet?.setTitle(name, for: .normal)
    }
    
}
