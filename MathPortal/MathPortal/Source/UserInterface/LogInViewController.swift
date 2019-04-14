//
//  LogInViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet private var logInUsernameTextField: UITextField?
    @IBOutlet private var logInPasswordTextField: UITextField?
    @IBOutlet private var logInButton: UIButton?
    
    
    @IBOutlet private var signUpUsernameTextField: UITextField?
    @IBOutlet private var signUpPasswordTextField: UITextField?
    @IBOutlet private var signUpButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            goToLoggedInScreen()
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        logInUser()
    }
    
    @IBAction func signUp(_ sender: Any) {
        signUpNewUser()
    }
    
    func signUpNewUser() {
        let user = PFUser()
        user.username = signUpUsernameTextField?.text
        user.password = signUpPasswordTextField?.text
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        user.signUpInBackground { (success, error) in
            loadingSpinner.dismissLoadingScreen()
            if success {
                self.goToLoggedInScreen()
            } else {
                if let descrip = error?.localizedDescription {
                    ErrorMessage.displayErrorMessage(controller: self, message: descrip)
                }
            }
        }
    }
    
    func logInUser() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        guard let username = logInUsernameTextField?.text, let password = logInPasswordTextField?.text  else {
            loadingSpinner.dismissLoadingScreen()
            return }
        PFUser.logInWithUsername(inBackground: username, password: password ) { (user, error) in
            loadingSpinner.dismissLoadingScreen()
            if user != nil {
                self.goToLoggedInScreen()
            } else {
                if let descrip = error?.localizedDescription{
                    ErrorMessage.displayErrorMessage(controller: self, message: (descrip))
                }
            }
        }
    }
   
    func goToLoggedInScreen() {
        let controller = R.storyboard.main.loggedInViewController()!
        navigationController?.pushViewController(controller, animated: true)
    }

}
