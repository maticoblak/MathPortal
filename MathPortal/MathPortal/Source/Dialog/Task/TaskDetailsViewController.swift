//
//  TaskDetailsViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TaskDetailsViewController: UIViewController {

    @IBOutlet private var equationsTableView: UITableView?
    
    var task: Task!
    private var cells: [CellType] = [CellType]()
    
    private enum CellType {
         case title(taskTitle: String)
        case equation(expressionView: UIView?)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equationsTableView?.allowsSelection = false
        reloadData()
    }
    
    private func reloadData() {
        var cells: [CellType] = [CellType]()
        if let taskTitle = task.name { cells.append(.title(taskTitle: taskTitle)) }
        task.equations?.forEach { cells.append(.equation(expressionView: $0.expression.generateView().view) ) }
        self.cells = cells
    }
}

extension TaskDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.taskDetailsViewControllerTableViewCell, for: indexPath)!
        switch cells[indexPath.row] {
        case .title(let taskTitle):
            cell.setupCell(title: taskTitle)
        case .equation(let expressionView):
            cell.setupCell(expressionView: expressionView)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cells[indexPath.row] {
        case .title(_):
            return 44 + 10
        case .equation(let expressionView):
            return (expressionView?.frame.height ?? 44) + 10
        }
    }
    
}
