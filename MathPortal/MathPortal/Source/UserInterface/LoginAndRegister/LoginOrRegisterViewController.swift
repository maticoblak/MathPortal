//
//  LoginOrRegisterViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 01/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class LoginOrRegisterViewController: UIViewController {

    @IBOutlet private var registerButton: UIButton?
    @IBOutlet private var loginButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupButtons()
    }

    private func setupButtons() {
        
        if let registerButton = registerButton {
            registerButton.layer.cornerRadius = registerButton.frame.size.width/2
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        goToLoginScreen()
    }
    
    private func goToLoginScreen() {
        let controller = R.storyboard.main.logInViewController()!
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
