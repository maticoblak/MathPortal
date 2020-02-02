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
    @IBOutlet private var addEquationButton: UIButton?
    
    @IBOutlet private var equationsTableView: CustomTableView?
    @IBOutlet private var backgroundContentView: UIView?
    
    private var equationsAndTexts: [Equation] = [Equation]()
    
    private var currentSelectedEquationIndex: Int?
    
    var task: Task!

    override func viewDidLoad() {
        super.viewDidLoad()

        equationsAndTexts = task.equations ?? [Equation]()
        titleTextField?.text = task.name
        equationsTableView?.register(R.nib.taskViewControllerTableViewCell)
        
        equationsTableView?.customDelegate = self
        
        setupViews()
        setUpDefaultKeyboard()
        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToCreatedTasksViewController), rightBarButtonTitle: "Save", rightBarButtonAction: #selector(saveTask))
    
    }
    private func setUpDefaultKeyboard() {
        titleTextField?.extras.addToolbar(doneButton: (selector: #selector(self.dismissDefaultKeyboard), target: self))
    }
    
    private func setupViews() {
        addEquationButton?.tintColor = Color.darkBlue
        addEquationButton?.layer.borderWidth = 2
        addEquationButton?.layer.borderColor = Color.darkBlue.cgColor
        addEquationButton?.layer.cornerRadius = (addEquationButton?.bounds.height ?? 5)/2
        addEquationButton?.backgroundColor = Color.lightGrey
        
        backgroundContentView?.layer.cornerRadius = 10
        backgroundContentView?.layer.borderWidth = 2
        backgroundContentView?.layer.borderColor = Color.darkBlue.cgColor
        
        view.backgroundColor = Color.lightGrey
        equationsTableView?.layer.cornerRadius = 10
    }
    
    @objc func dismissDefaultKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func goToEquationViewController() {
        let controller = R.storyboard.createdTasksViewController.mathEquationViewController()!
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func goToCreatedTasksViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTask() {
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
            if equation.expression.items.isEmpty {
                equationsAndTexts.remove(at: currentSelectedEquationIndex)
            } else {
                equationsAndTexts[currentSelectedEquationIndex] = equation
            }
        } else if equation.expression.items.isEmpty == false {
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
