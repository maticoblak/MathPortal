//
//  SolvedTasksViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolvedTasksViewController: UIViewController {
    
    let user = User()
    private var tasks: [Task] = [Task]()
    @IBOutlet private var tasksTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.setUpNavigationController(controller: self)
        user.updateUser()
        reloadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        user.updateUser()
        reloadTasks()
    }
    
    private func reloadTasks() {
        Task.fetchSolvedTasks(objectIds: user.tasksOwned.map {$0.key}) { (tasks, error) in
            if let tasks = tasks {
                self.tasks = tasks
                self.tasksTableView?.reloadData()
            } else if let error = error {
                print(error)
            }
        }
    }
    
    static func createFromStoryboard() -> SolvedTasksViewController {
        return UIStoryboard(name: "SolvedTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "SolvedTasksViewController") as! SolvedTasksViewController
    }

}
extension SolvedTasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.solvedTasksViewControllerTableViewCell, for: indexPath)!
        cell.setUpCell(taskName: tasks[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = R.storyboard.solvedTasksViewController.solveTaskViewController()!
        controller.user = user
        controller.task = tasks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
