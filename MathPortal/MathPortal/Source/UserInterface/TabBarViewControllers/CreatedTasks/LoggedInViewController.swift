//
//  LoggedInViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class LoggedInViewController: UIViewController {

 
    @IBOutlet private var tasksTableView: UITableView?
    
    private var tasks: [Task] = [Task]()
    
    var user: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasksTableView?.tableFooterView = UIView()
        Appearence.setUpNavigationController(controller: self)
        Appearence.addRightBarButton(controller: self, rightBarButtonTitle: "Add task", rightBarButtonAction: #selector(addTask))
        reloadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        user.updateUser()
        reloadTasks()
    }
    
    private func reloadTasks() {
        guard let userId = user.userId else { return  }
        Task.fetchUserTasks(userId: userId, completion: { (tasks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let tasks = tasks {
                self.tasks = tasks
                self.tasksTableView?.reloadData()
                self.user.tasks = tasks.compactMap { $0.name }
                self.user.save(completion: nil)
            }
        })
    }
    @objc func addTask() {
        let controller = R.storyboard.main.taskViewController()!
        controller.task = Task()
        navigationController?.pushViewController(controller, animated: true)
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
    
    
    static func createFromStoryboard() -> LoggedInViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
    }
}

