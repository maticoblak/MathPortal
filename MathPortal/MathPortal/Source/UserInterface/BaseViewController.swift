//
//  BaseViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 04/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mathDarkBlue
        self.navigationController?.navigationBar.backgroundColor = UIColor.mathDarkBlue
        
        guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else {
            return
        }
        statusBarView.backgroundColor = UIColor.mathDarkGrey
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
