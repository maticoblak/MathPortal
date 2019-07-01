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
    @IBOutlet private var imageView: UIView?
    
    @IBOutlet private var profileImage: UIImageView?
    
    @IBOutlet private var emailLabel: UILabel?
    
    @IBOutlet private var memberSinceLabel: UILabel?
    
    @IBOutlet private var ageLabel: UILabel?
    @IBOutlet private var roleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.setUpNavigationController(controller: self)
        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "Log out", leftBarButtonAction: #selector(logoutOfApp), rightBarButtonTitle: "Edit Profile", rightBarButtonAction: #selector(editProfile))
        refreshUserProfile()
    }
    
    @objc private func editProfile() {
        let controller = R.storyboard.userViewController.editUserViewController()!
        controller.user = user
        navigationController?.pushViewController(controller, animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.user.updateUser()
        self.refreshUserProfile()
    }
    func refreshUserProfile() {
        tasksLabel?.text = String(describing: user.tasks?.count ?? 0) 
        usernameLabel?.text = user.username
        memberSinceLabel?.text = user.dateCreated
        roleLabel?.text = user.role.map { $0.string }.joined(separator: ", ")
        ageLabel?.text = user.age == nil ? "Undefined" : String(describing: user.age ?? 0)
        emailLabel?.text = user.email
        profileImage?.image = user.profileImage ?? R.image.profile()
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
