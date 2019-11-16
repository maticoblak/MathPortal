//
//  TaskViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class TaskViewController: UIViewController {

    @IBOutlet private var titleTextField: UITextField?
    @IBOutlet private var saveButton: UIButton?
    
    @IBOutlet var equationsTableView: CustomTableView?
    
    private var equationsAndTexts: [Equation] = [Equation]()
    
    private var currentSelectedEquationIndex: Int?
    
    var task: Task!
    
    var saveButtonHidden: Bool = false {
        didSet {
            saveButton?.isHidden = saveButtonHidden
        }
    }
    var mathKeyboardOpened: Bool = false {
        didSet {
            saveButtonHidden = !saveButtonHidden
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToCreatedTasksViewController), rightBarButtonTitle: "+", rightBarButtonAction: #selector(goToEquationViewController))
    
        equationsAndTexts = task.equations ?? [Equation]()
        titleTextField?.text = task.name
        equationsTableView?.register(R.nib.taskViewControllerTableViewCell)
        setUpDefaultKeyboard()
        
        equationsTableView?.customDelegate = self
    }
    private func setUpDefaultKeyboard() {
        titleTextField?.extras.addToolbar(doneButton: (selector: #selector(self.dismissDefaultKeyboard), target: self))
    }
    
    @objc func dismissDefaultKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goToEquationViewController() {
        let controller = R.storyboard.createdTasksViewController.mathEquationViewController()!
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func saveTask(_ sender: Any) {
        saveTask()
    }
    
    @objc func goToCreatedTasksViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func saveTask() {
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Saving")
        
        task.name = titleTextField?.text
        task.equations = equationsAndTexts
        task.ownerId = User.current?.userId
        
        task.save(completion: { (success, error) in
            loadingSpinner.dismissFromCurrentWindow() {
                if success {
                    self.goToCreatedTasksViewController()
                } else if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Something went wrong while saving task.")
                }
            }
        })
    }
}

extension TaskViewController: MathEquationViewControllerDelegate {
    func mathEquationViewController(sender: MathEquationViewController, didWriteEquation equation: Equation) {
        if let currentSelectedEquationIndex = currentSelectedEquationIndex {
            equationsAndTexts[currentSelectedEquationIndex] = equation
        } else {
            equationsAndTexts.append(equation)
        }
        currentSelectedEquationIndex = nil 
        equationsTableView?.reloadData()
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equationsAndTexts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.taskViewControllerTableViewCell, for: indexPath)!
        cell.setupCell(delegate: self, equation: equationsAndTexts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = equationsAndTexts[indexPath.row].viewBounds().height ?? 44
        return height + 10
    }
}

extension TaskViewController: TaskViewControllerTableViewCellDelegate {
    func taskViewControllerTableViewCell(sender: TaskViewControllerTableViewCell, didDeleteCellAt location: CGPoint) {
        guard let indexPath = equationsTableView?.indexPathForRow(at: location) else { return }
        equationsAndTexts.remove(at: indexPath.row)
        equationsTableView?.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func taskViewControllerTableViewCell(sender: TaskViewControllerTableViewCell, didSelectCellAt location: CGPoint) {
        guard let indexPath = equationsTableView?.indexPathForRow(at: location) else { return }
        currentSelectedEquationIndex = indexPath.row
        let controller = R.storyboard.createdTasksViewController.mathEquationViewController()!
        controller.delegate = self
        controller.equation = equationsAndTexts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}


extension TaskViewController: CustomTableViewDelegate {
    func customTableView(_ sender: CustomTableView, didMoveCellAt previousIndexPath: IndexPath, to currentIndexPath: IndexPath) {
        let itemToMove = equationsAndTexts[previousIndexPath.row]
        equationsAndTexts.remove(at: previousIndexPath.row)
        equationsAndTexts.insert(itemToMove, at: currentIndexPath.row)
    }
}
