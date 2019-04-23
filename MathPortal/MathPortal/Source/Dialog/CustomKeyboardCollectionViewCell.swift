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
    
    func setKey(name: String) {
        keyboardKeyLabel?.text = name
    }
}
