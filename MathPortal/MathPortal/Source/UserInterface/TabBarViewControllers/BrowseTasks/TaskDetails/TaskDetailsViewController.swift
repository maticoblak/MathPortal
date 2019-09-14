//
//  TaskDetailsViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    var task: Task!
    @IBOutlet private var equationsTableView: UITableView?
    
    private var equations: [Equation] = [Equation]()
    private var taskTitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        equations = task.equations ?? [Equation]()
        taskTitle = task.name
        equationsTableView?.allowsSelection = false
        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "< Back", leftBarButtonAction: #selector(goBack), rightBarButtonTitle: "Solve", rightBarButtonAction: #selector(goToSolveScreen))
    }
    
    @objc private func goToSolveScreen() {
        guard let user = User.current else { return }
        user.tasksOwned[task.objectId] = false
        user.save { (success, error) in
            if success {
                //TODO: go to solve task screen
            } else if let error = error {
                print(error)
            }
        }
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension TaskDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.taskDetailsViewControllerTableViewCell, for: indexPath)!
        if indexPath.row == 0 {
            cell.setupCell(title: taskTitle)
        } else {
            cell.setupCell(equation: equations[indexPath.row - 1])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44
        if indexPath.row != 0 {
            height = (equations[indexPath.row - 1].expression.generateView().view?.frame.height ?? 44) + 10
        }
        return height
    }
    
}
