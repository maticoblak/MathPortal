//
//  SolvedTasksViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 11/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol SolvedTasksViewControllerDelegate: class {
    func solvedTasksViewController(_ sender: SolvedTasksViewController)
}

class SolvedTasksViewController: UIViewController {
    
    private var tasks: [Task] = [Task]()
    @IBOutlet private var noTasksView: UIView!
    @IBOutlet private var tasksTableView: UITableView?
    
    weak var delegate: SolvedTasksViewControllerDelegate?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        noTasksView.isHidden = true
        Appearence.setUpNavigationController(controller: self)
        tasksTableView?.backgroundColor = Color.darkGrey
        reloadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadTasks()
    }
    
    @IBAction private func solveMyFirstTask(_ sender: Any) {
        delegate?.solvedTasksViewController(self)
    }
    private func reloadTasks() {
        User.current?.fetchSavedTasks() { (tasks, error) in
            if let tasks = tasks {
                self.tasks = tasks
                self.noTasksView.isHidden = !tasks.isEmpty
                self.tasksTableView?.reloadData()
            } else if let error = error {
                print(error)
            }
        }
    }
    
    static func createFromStoryboard(delegate: SolvedTasksViewControllerDelegate) -> SolvedTasksViewController {
        let controller = (UIStoryboard(name: "SolvedTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "SolvedTasksViewController") as! SolvedTasksViewController)
        controller.delegate = delegate
        return controller
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
            // TODO: Figure out what to delete
            guard let currentUser = User.current else { return }
            currentUser.removeFromSavedTasks(tasks[indexPath.row]) { (success, error) in
                self.reloadTasks()
            }
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
