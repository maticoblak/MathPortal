//
//  BrowseTasksViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class BrowseTasksViewController: UIViewController {

    @IBOutlet private var tasksTableView: UITableView?
    
    var tasks: [Task] = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tasksTableView?.tableFooterView = UIView()
        Appearence.setUpNavigationController(controller: self)
        tasksTableView?.backgroundColor = Color.darkGrey
        relodeAllTasks()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        relodeAllTasks()
    }
    
    
    private func relodeAllTasks() {
        Task.fetchAllTasks { (tasks, error) in
            if let error = error {
                print(error)
            } else if let tasks = tasks {
                self.tasks = tasks
                self.tasksTableView?.reloadData()
            }
        }
    }
    
    static func createFromStoryboard() -> BrowseTasksViewController {
        return UIStoryboard(name: "BrowseTasksViewController", bundle: nil).instantiateViewController(withIdentifier: "BrowseTasksViewController") as! BrowseTasksViewController
    }
}

extension BrowseTasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.browseViewControllerTableViewCell, for: indexPath)!
        cell.setupCell(taskTitle: tasks[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = R.storyboard.browseTasksViewController.browseSelectedTaskViewController()!
        controller.task = tasks[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BrowseViewControllerTableViewCell
        cell.cellIsSelected = true
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BrowseViewControllerTableViewCell
        cell.cellIsSelected = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
