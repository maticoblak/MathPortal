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

    @IBOutlet private var scrollView: UIScrollView?
    
    @IBOutlet private var logInUsernameTextField: UITextField?
    @IBOutlet private var logInPasswordTextField: UITextField?
    @IBOutlet private var logInButton: UIButton?
    
    
    @IBOutlet private var signUpUsernameTextField: UITextField?
    @IBOutlet private var signUpPasswordTextField: UITextField?
    @IBOutlet private var signUpEmailTextField: UITextField?
    @IBOutlet private var signUpButton: UIButton?
    
    @IBOutlet private var bottomLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardManager.sharedInstance.willChangeFrameDelegate = self
    }
    
    private func keyboardSetup() {
        logInUsernameTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        logInPasswordTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        signUpUsernameTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        signUpPasswordTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let currentUser = PFUser.current()
        if currentUser != nil {
            goToMainMenuViewController()
        }
    }
    
    @IBAction private func logIn(_ sender: Any) {
        logInUser()
    }
    
    @IBAction private func signUp(_ sender: Any) {
        validateAndSignUp()
    }

    private func signUpNewUser(user: PFUser) {
        
        
        
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        
        
        user.signUpInBackground { (success, error) in
            loadingSpinner.dismissLoadingScreen() {
                if success == false {
                    if let description = error?.localizedDescription {
                        ErrorMessage.displayErrorMessage(controller: self, message: description)
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                    }
                } else if user.email?.count == 0 {
                    ErrorMessage.displayErrorMessage(controller: self, message: "Missing email")
                } else if success {
                    self.goToMainMenuViewController()
                }
            }
        }
    }
    
    private func validateAndSignUp() {
        let user = PFUser()
        user.username = signUpUsernameTextField?.text
        user.password = signUpPasswordTextField?.text
        user.email = signUpEmailTextField?.text
        FieldValidator.init(validate: [.username, .email], username: user.username, email: user.email, age: nil).validate { result in
            switch result {
            case .OK:
                self.signUpNewUser(user: user)
            case .emailInvalid, .ageInvalid, .emailAlreadyTaken, .usernameAlreadyTaken:
                ErrorMessage.displayErrorMessage(controller: self, message: result.error)
                break
            }
        }
    }
    
    private func logInUser() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        guard let username = logInUsernameTextField?.text, let password = logInPasswordTextField?.text  else { loadingSpinner.dismissLoadingScreen() { return }; return }
        PFUser.logInWithUsername(inBackground: username, password: password ) { (user, error) in
            loadingSpinner.dismissLoadingScreen() {
                if user != nil {
                    self.goToMainMenuViewController()
                } else {
                    if let description = error?.localizedDescription {
                        ErrorMessage.displayErrorMessage(controller: self, message: (description))
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                    }
                }
            }
        }
    }
   
//    func goToLoggedInScreen() {
//        let controller = R.storyboard.main.loggedInViewController()!
//        navigationController?.pushViewController(controller, animated: true)
//    }
    func goToMainMenuViewController() {
        let controller = R.storyboard.main.tabBarViewController()!
        self.present(controller, animated: true)
    }

}
extension LogInViewController: KeyboardManagerWillChangeFrameDelegate {
    func keyboardManagerWillChangeKeyboardFrame(sender: KeyboardManager, from startFrame: CGRect, to endFrame: CGRect) {
        
        bottomLayoutConstraint?.constant = self.view.bounds.height - self.view.convert(endFrame, from: nil).minY
        self.view.layoutIfNeeded()
        
        if self.signUpUsernameTextField?.isFirstResponder == true || self.signUpPasswordTextField?.isFirstResponder == true {
            scrollView?.extras.scrollToViews([signUpPasswordTextField, signUpUsernameTextField, signUpButton])
        } else if self.logInPasswordTextField?.isFirstResponder == true || self.logInUsernameTextField?.isFirstResponder == true {
            scrollView?.extras.scrollToViews([logInPasswordTextField, logInUsernameTextField, logInButton])
        }
    }
}

