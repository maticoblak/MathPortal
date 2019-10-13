//
//  SolvedTasksViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolvedTasksViewController: UIViewController {
    
    private var tasks: [Task] = [Task]()
    @IBOutlet private var tasksTableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Appearence.setUpNavigationController(controller: self)
        tasksTableView?.backgroundColor = UIColor.mathDarkGrey
        reloadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTasks()
    }
    
    private func reloadTasks() {
        User.current?.fetchSavedTasks() { (tasks, error) in
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
        controller.task = tasks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks[indexPath.row].delete(completion: { (success, error) in
                self.tasks.remove(at: indexPath.row)
                self.reloadTasks()
            })
        }
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SolvedTasksViewControllerTableViewCell
        cell.cellIsSelected = true
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SolvedTasksViewControllerTableViewCell
        cell.cellIsSelected = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
