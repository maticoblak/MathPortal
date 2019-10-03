//
//  SolveTaskViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 25/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolveTaskViewController: UIViewController {

    @IBOutlet private var taskContentController: ContentControllerView?
    @IBOutlet private var equationsTableView: CustomTableView?
    
    var task: Task!
    var solution: TaskSolution = TaskSolution()
    
    private var equations: [Equation] = [Equation]()
    private var currentSelectedEquationIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        taskContentController?.setViewController(controller: {
            let controller = R.storyboard.taskDetailsViewController.taskDetailsViewController()
            controller?.task = task
            return controller
        }(), animationStyle: .fade)
        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "< Back", leftBarButtonAction: #selector(goBack), rightBarButtonTitle: "Save", rightBarButtonAction: #selector(save))
        taskContentController?.layer.cornerRadius = 10
        equationsTableView?.layer.cornerRadius = 10
        equationsTableView?.register(R.nib.taskViewControllerTableViewCell)
        equationsTableView?.customDelegate = self
        reloadSolution()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !equations.isEmpty {
            equationsTableView?.scrollToRow(at: IndexPath(row: equations.count - 1, section: 0), at: .middle, animated: false)
        }
    }
    
    @IBAction func addEquation(_ sender: Any) {
        let controller = R.storyboard.createdTasksViewController.mathEquationViewController()!
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func save() {
        saveSolution()
    }
    
    func saveSolution() {
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Saving")
        solution.ownerId = User.current?.userId
        solution.taskId = task.objectId
        solution.equations = equations
        solution.save(completion: { (success, error) in
            loadingSpinner.dismissFromCurrentWindow() {
                if success {
                    self.goBack()
                } else if let error = error {
                    print(error)
                }
            }
        })
    }
    
    private func reloadSolution() {
        guard let userId = User.current?.userId else { return }
        TaskSolution.fechUsersTaskSolution(task.objectId, userId: userId) { (solution, error) in
            if let error = error {
                print(error)
            } else if let solution = solution, let equations = solution.equations {
                self.solution = solution
                self.equations = equations
                self.equationsTableView?.reloadData()
            }
        }
    }
}
extension SolveTaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.taskViewControllerTableViewCell, for: indexPath)!
        cell.setupCell(delegate: self, equation: equations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = equations[indexPath.row].expression.generateView().view?.frame.height ?? 44
        return height + 10
    }
    
    
}
extension SolveTaskViewController: TaskViewControllerTableViewCellDelegate {
    func taskViewControllerTableViewCell(sender: TaskViewControllerTableViewCell, didDeleteCellAt location: CGPoint) {
        guard let indexPath = equationsTableView?.indexPathForRow(at: location) else { return }
        equations.remove(at: indexPath.row)
        equationsTableView?.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func taskViewControllerTableViewCell(sender: TaskViewControllerTableViewCell, didSelectCellAt location: CGPoint) {
        guard let indexPath = equationsTableView?.indexPathForRow(at: location) else { return }
        currentSelectedEquationIndex = indexPath.row
        let controller = R.storyboard.createdTasksViewController.mathEquationViewController()!
        controller.delegate = self
        controller.equation = equations[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SolveTaskViewController: MathEquationViewControllerDelegate {
    func mathEquationViewController(sender: MathEquationViewController, didWriteEquation equation: Equation) {
        if let currentSelectedEquationIndex = currentSelectedEquationIndex {
            equations[currentSelectedEquationIndex] = equation
        } else {
            equations.append(equation)
        }
        currentSelectedEquationIndex = nil
        equationsTableView?.reloadData()
    }
}

extension SolveTaskViewController: CustomTableViewDelegate {
    func customTableView(_ sender: CustomTableView, didMoveCellAt previousIndexPath: IndexPath, to currentIndexPath: IndexPath) {
        let itemToMove = equations[previousIndexPath.row]
        equations.remove(at: previousIndexPath.row)
        equations.insert(itemToMove, at: currentIndexPath.row)
    }
}

