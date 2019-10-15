//
//  RegisterViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 01/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: BaseViewController {

    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var backButton: UIButton?
    @IBOutlet private var usernameTextFieeld: UITextField?
    @IBOutlet private var emailTextField: UITextField?
    @IBOutlet private var passwordTextField: UITextField?
    @IBOutlet private var signUpButton: UIButton?
    
    @IBOutlet private var botomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardSetup()
        setup()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardManager.sharedInstance.willChangeFrameDelegate = self
    }

    @IBAction private func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func registerUser(_ sender: Any) {
        validateAndSignUp()
    }
    
    private func setup() {
        signUpButton?.backgroundColor = .clear
        signUpButton?.layer.borderWidth = 1.5
        signUpButton?.layer.borderColor = Color.pink.cgColor
    }
    
    private func signUpNewUser() {
        guard let username = usernameTextFieeld?.text, let password = passwordTextField?.text, let email = emailTextField?.text else { return }
    
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Loading")
        User.signUpUser(username: username, password: password, email: email) { (success, error) in
            loadingSpinner.dismissFromCurrentWindow() {
                if success == false {
                    if let description = error?.localizedDescription {
                        ErrorMessage.displayErrorMessage(controller: self, message: description)
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "Unknown error occurred")
                    }
                } else if email.count == 0 {
                    ErrorMessage.displayErrorMessage(controller: self, message: "Missing email")
                } else {
                    self.goToOnboarding()
                }
            }
        }
    }
    
    private func validateAndSignUp() {
        FieldValidator.init(validate: [.username, .email], username: usernameTextFieeld?.text, email: emailTextField?.text, age: nil).validate { result in
            switch result {
            case .OK:
                self.signUpNewUser()
            case .emailInvalid, .ageInvalid, .emailAlreadyTaken, .usernameAlreadyTaken:
                ErrorMessage.displayErrorMessage(controller: self, message: result.error)
                break
            }
        }
    }
    
    private func goToOnboarding() {
        let controller = R.storyboard.onboarding.onboardingRoleViewController()!
        let navigationController = UINavigationController(rootViewController: controller)
        self.presentAsFullScreen(navigationController, animated: true)
    }
}

extension RegisterViewController: KeyboardManagerWillChangeFrameDelegate {
    private func keyboardSetup() {
        usernameTextFieeld?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        passwordTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        emailTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardManagerWillChangeKeyboardFrame(sender: KeyboardManager, from startFrame: CGRect, to endFrame: CGRect) {
        
        botomConstraint?.constant = self.view.bounds.height - self.view.convert(endFrame, from: nil).minY
        self.view.layoutIfNeeded()
        
        if self.usernameTextFieeld?.isFirstResponder == true || self.passwordTextField?.isFirstResponder == true {
            scrollView?.extras.scrollToViews([passwordTextField, usernameTextFieeld, signUpButton])
        }
    }
}
