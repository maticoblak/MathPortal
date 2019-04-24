//
//  KeyboardManager.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class KeyboardManager {
    
    static func addDoneButton(selector: Selector, target: UIViewController) -> UIToolbar  {
        let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let accessoryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: selector)
        accessoryToolBar.items = [accessoryDoneButton]
        return accessoryToolBar
    }
}
