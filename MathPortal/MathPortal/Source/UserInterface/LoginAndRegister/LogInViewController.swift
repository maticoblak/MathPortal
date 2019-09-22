//
//  LogInViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: BaseViewController {

    @IBOutlet private var scrollView: UIScrollView?
    
    @IBOutlet private var logInUsernameTextField: UITextField?
    @IBOutlet private var logInPasswordTextField: UITextField?
    @IBOutlet private var logInButton: UIButton?
    @IBOutlet private var backButton: UIButton?
    
    @IBOutlet private var bottomLayoutConstraint: NSLayoutConstraint?
    
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
    
    private func setup() {
        logInButton?.backgroundColor = .clear
        logInButton?.layer.borderWidth = 1.5
        logInButton?.layer.borderColor = UIColor.mathPink.cgColor
        
        backButton?.imageView?.tintColor = UIColor.mathLightGrey
    }
    
    private func keyboardSetup() {
        logInUsernameTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))
        logInPasswordTextField?.extras.addToolbar(doneButton: (selector: #selector(dismissKeyboard), target: self))

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    
    @IBAction private func logIn(_ sender: Any) {
        logInUser()
    }
    
    private func logInUser() {
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Loading")
        guard let username = logInUsernameTextField?.text, let password = logInPasswordTextField?.text  else { loadingSpinner.dismissFromCurrentWindow(); return }
        User.logIn(username: username, password: password) { (user, error) in
            loadingSpinner.dismissFromCurrentWindow() {
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
   
    private func goToMainMenuViewController() {
        let controller = R.storyboard.main.tabBarViewController()!
        self.present(controller, animated: true)
    }
}

extension LogInViewController: KeyboardManagerWillChangeFrameDelegate {
    func keyboardManagerWillChangeKeyboardFrame(sender: KeyboardManager, from startFrame: CGRect, to endFrame: CGRect) {
        
        bottomLayoutConstraint?.constant = self.view.bounds.height - self.view.convert(endFrame, from: nil).minY
        self.view.layoutIfNeeded()
        scrollView?.extras.scrollToViews([logInPasswordTextField, logInUsernameTextField, logInButton])
    }
}

