//
//  ExtrasCGFloat+Random.swift
//  AppDesign
//
//  Created by Matic Oblak on 04/04/2019.
//  Copyright © 2019 umwerk. All rights reserved.
//

import UIKit

extension CGFloatExtras {

    static func random(min: CGFloat = 0.0, max: CGFloat = 1.0, strength: Int = 1000) -> CGFloat {
        let integer = Int(arc4random())%strength
        let scale = CGFloat(integer)/CGFloat(strength)
        return min + (max-min)*scale
    }
    
}
