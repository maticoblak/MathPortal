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
        keyboardSetup()
        
    }
    
    private func keyboardSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        logInUsernameTextField?.inputAccessoryView = KeyboardManager.addDoneButton(selector: #selector(dismissKeyboard), target: self)
        logInPasswordTextField?.inputAccessoryView = KeyboardManager.addDoneButton(selector: #selector(dismissKeyboard), target: self)
        signUpUsernameTextField?.inputAccessoryView = KeyboardManager.addDoneButton(selector: #selector(dismissKeyboard), target: self)
        signUpPasswordTextField?.inputAccessoryView = KeyboardManager.addDoneButton(selector: #selector(dismissKeyboard), target: self)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentUser = PFUser.current()
        if currentUser != nil {
            goToLoggedInScreen()
        }
    }
    
    @IBAction private func logIn(_ sender: Any) {
        logInUser()
    }
    
    @IBAction private func signUp(_ sender: Any) {
        signUpNewUser()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if (self.signUpUsernameTextField?.isFirstResponder == true || self.signUpPasswordTextField?.isFirstResponder == true) {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    private func signUpNewUser() {
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
                if let description = error?.localizedDescription {
                    ErrorMessage.displayErrorMessage(controller: self, message: description)
                } else {
                    ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                }
            }
        }
    }
    
    private func logInUser() {
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
                if let description = error?.localizedDescription {
                    ErrorMessage.displayErrorMessage(controller: self, message: (description))
                } else {
                    ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                }
            }
        }
    }
   
    func goToLoggedInScreen() {
        let controller = R.storyboard.main.loggedInViewController()!
        navigationController?.pushViewController(controller, animated: true)
    }

}

