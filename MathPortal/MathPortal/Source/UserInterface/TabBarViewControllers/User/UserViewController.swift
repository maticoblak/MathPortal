//
//  UserViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 10/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class UserViewController: BaseViewController {
    
    @IBOutlet private var tasksLabel: UILabel?
    @IBOutlet private var solvedTasksLabel: UILabel?
    @IBOutlet private var usernameLabel: UILabel?
    @IBOutlet private var imageView: UIView?
    
    @IBOutlet private var profileImage: UIImageView?
    
    @IBOutlet private var emailLabel: UILabel?
    
    @IBOutlet private var memberSinceLabel: UILabel?
    
    @IBOutlet private var ageLabel: UILabel?
    @IBOutlet private var roleLabel: UILabel?
    @IBOutlet private var editButton: UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.setUpNavigationController(controller: self)
        editButton?.imageView?.tintColor = Color.darkGrey
        refreshUserProfile()
    }
    
    @IBAction private func goToEditProfile(_ sender: Any) {
        let controller = R.storyboard.userViewController.editUserViewController()!
        let navigationController = UINavigationController(rootViewController: controller)
        self.present(navigationController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    
    private func refreshUserProfile() {
        guard let user = User.current else { return }
        
        usernameLabel?.text = user.username
        memberSinceLabel?.text = user.dateCreated
        roleLabel?.text = user.role.map { $0.string }.joined(separator: ", ")
        ageLabel?.text = String(DateTools.getAgeFromDate(date: user.birthDate) ?? 0)
        emailLabel?.text = user.email
        profileImage?.image = user.profileImage ?? R.image.profile()
        getData(user: user)
    }
    
    private func getData(user: User) {
        guard let currentUserId = user.userId else { return }
        Task.fetchTasksWith(userId: currentUserId) { (tasks, error) in
            if let tasks = tasks {
                self.tasksLabel?.text = String(tasks.count)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        TaskSolution.fetchUsersTaskSolutions(userId: currentUserId) { (solutions, error) in
            if let solutions = solutions {
                self.solvedTasksLabel?.text = String(solutions.count)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction private func logOut(_ sender: Any) {
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Loading")
        
        User.logOut { (error: Error?) in
            loadingSpinner.dismissFromCurrentWindow() {
                if error == nil {
                    let controller = R.storyboard.main.loginOrRegisterViewController()!
                    let navigationController = UINavigationController.init(rootViewController: controller)
                    self.presentAsFullScreen(navigationController, animated: true)
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
