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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equationsTableView?.allowsSelection = false
        
    }
}

extension TaskDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (task.equations?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.taskDetailsViewControllerTableViewCell, for: indexPath)!
        if indexPath.row == 0 {
            cell.setupCell(title: task.name )
        } else {
            cell.setupCell(equation: task.equations?[indexPath.row - 1])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 44
        if indexPath.row != 0 {
            height = (task.equations?[indexPath.row - 1].expression.generateView().view?.frame.height ?? 44) + 10
        }
        return height
    }
    
}
