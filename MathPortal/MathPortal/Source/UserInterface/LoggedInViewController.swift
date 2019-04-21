//
//  LoggedInViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class LoggedInViewController: UIViewController {

    @IBOutlet private var logOutButton: UIButton?
    @IBOutlet private var tasksTableView: UITableView?
    
    private var tasks: [Task] = [Task]()
    
    let user = PFUser.current()
    
    @IBAction func logOut(_ sender: Any) {
        logoutOfApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasksTableView?.tableFooterView = UIView()
        Appearence.addRightBarButton(controller: self, rightBarButtonTitle: "Add Task", rightBarButtonAction: #selector(addTask))
        reloadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTasks()
    }
    
    private func reloadTasks() {
        guard let userId = user?.objectId else { return  }
        Task.fetchUserTasks(userId: userId, completion: { (tasks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let tasks = tasks {
                self.tasks = tasks
                self.tasksTableView?.reloadData()
            }
        })
    }
    @objc func addTask() {
        let controller = R.storyboard.main.taskViewController()!
        controller.task = Task()
        navigationController?.pushViewController(controller, animated: true)
    }
    func logoutOfApp() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Loading")
        self.present(loadingSpinner, animated: false, completion: nil)
        
        PFUser.logOutInBackground { (error: Error?) in
            loadingSpinner.dismissLoadingScreen()
            if error == nil {
                self.navigationController?.popViewController(animated: true)
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

extension LoggedInViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! LoggedInViewControllerTableViewCell
        cell.task = tasks[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = R.storyboard.main.taskViewController()!
        controller.task = tasks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks[indexPath.row].delete(completion: { (success, error) in
                self.reloadTasks()
            }) 
        }
    }
}
