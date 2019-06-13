//
//  UserViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 10/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController {
    
    let user = User()

    @IBOutlet private var tasksLabel: UILabel?
    @IBOutlet private var usernameLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.setUpNavigationController(controller: self)
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "Log out", leftBarButtonAction: #selector(logoutOfApp))
        refreshUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        user.updateUser()
        refreshUserProfile()
    }
    func refreshUserProfile() {
        tasksLabel?.text = String(describing: user.tasks?.count ?? 0) 
        usernameLabel?.text = user.username
    }
    
    @objc func logoutOfApp() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        
        PFUser.logOutInBackground { (error: Error?) in
            loadingSpinner.dismissLoadingScreen() {
                if error == nil {
                    let controller = R.storyboard.main.logInViewController()!
                    self.present(controller, animated: true )
                } else {
                    if let descrip = error?.localizedDescription{
                        ErrorMessage.displayErrorMessage(controller: self, message: descrip)
                    } else {
                        ErrorMessage.displayErrorMessage(controller: self, message: "error logging out")
                    }
                }
            }
        }
    }
    
    static func createFromStoryboard() -> UserViewController {
        return UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
    }
}
