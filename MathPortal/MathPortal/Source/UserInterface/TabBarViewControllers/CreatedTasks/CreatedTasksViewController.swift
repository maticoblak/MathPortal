//
//  CreatedTasksViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class CreatedTasksViewController: BaseViewController {

 
    @IBOutlet private var tasksTableView: UITableView?
    
    private var tasks: [Task] = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksTableView?.backgroundColor = UIColor.mathDarkGrey
        self.tasksTableView?.tableFooterView = UIView()
        Appearence.setUpNavigationController(controller: self)
        Appearence.addRightBarButton(controller: self, rightBarButtonTitle: "Add task", rightBarButtonAction: #selector(addTask))
        reloadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTasks()
    }
    
    private func reloadTasks() {
        guard let user = User.current else { return  }
        user.fetchTasks(completion: { (tasks, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let tasks = tasks {
                self.tasks = tasks
                self.tasksTableView?.reloadData()
            }
        })
    }
    @objc func addTask() {
        let controller = R.storyboard.createdTasksViewController.taskViewController()!
        controller.task = Task()
        navigationController?.pushViewController(controller, animated: true)
    }
    static func createFromStoryboard() -> CreatedTasksViewController {
        return UIStoryboard(name: "CreatedTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "CreatedTasksViewController") as! CreatedTasksViewController
    }
}

extension CreatedTasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! CreatedTasksViewControllerTableViewCell
        cell.task = tasks[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = R.storyboard.createdTasksViewController.taskViewController()!
        controller.task = tasks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CreatedTasksViewControllerTableViewCell
        cell.cellIsSelected = true
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CreatedTasksViewControllerTableViewCell
        cell.cellIsSelected = false
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

