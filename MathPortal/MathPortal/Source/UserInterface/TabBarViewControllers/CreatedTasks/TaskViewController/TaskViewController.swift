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
    
    @IBOutlet private var keyboardHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var keyboardContentControllerView: ContentControllerView?
    
    @IBOutlet var equationsTableView: UITableView?
    
    //private var equation: Equation = Equation()
    
    private var equationsAndTexts: [Equation] = [Equation]()
    
    private var currentSelectedEquationIndex: Int?
    
    private var previousIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var cellSnapshot: UIView = UIView()
    private var cellAndTapDifference: CGFloat = 0

    var task: Task!
    
    var taskTitle: String?
    
    var saveButtonHidden: Bool = false {
        didSet {
            saveButton?.isHidden = saveButtonHidden
        }
    }
    var mathKeyboardOpened: Bool = false {
        didSet {
            saveButtonHidden = !saveButtonHidden
            let height: CGFloat = mathKeyboardOpened ? 280 : 0
            keyboardHeightConstraint?.constant = height
            //scrollViewBottomConstraint?.constant = height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            //scrollView?.extras.scrollToViews([equationLabel])
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //KeyboardManager.sharedInstance.willChangeFrameDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHeightConstraint?.constant = 0
        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToLoggedInViewController), rightBarButtonTitle: "+", rightBarButtonAction: #selector(goToEquationViewController))
        
        taskTitle = task.name
        equationsAndTexts = task.equations ?? [Equation]()
        titleTextField?.text = taskTitle ?? "Title"
        equationsTableView?.register(R.nib.taskViewControllerTableViewCell)
        //equationsTableView?.isEditing = true
        setUpDefaultKeyboard()
        addLongPressGestureRecogniser()
    }
    private func setUpDefaultKeyboard() {
        titleTextField?.extras.addToolbar(doneButton: (selector: #selector(self.dismissDefaultKeyboard), target: self))
        //textView?.extras.addToolbar(doneButton: (selector: #selector(self.dismissDefaultKeyboard), target: self))
    }
    
    @objc func dismissDefaultKeyboard() {
        view.endEditing(true)
    }
    
    @objc func goToEquationViewController() {
        let controller = R.storyboard.main.mathEquationViewController()!
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func saveTask(_ sender: Any) {
        saveTask()
        self.goToLoggedInViewController()
        
    }
    @objc func goToLoggedInViewController() {
        navigationController?.popViewController(animated: true)
    }
    func saveTask() {
        let loadingSpinner = LoadingViewController.activateIndicator(text: "Saving")
        self.present(loadingSpinner, animated: false, completion: nil)

        task.name = titleTextField?.text
        task.equations = equationsAndTexts
        task.save(completion: { (success, error) in
            loadingSpinner.dismissLoadingScreen() {
                self.goToLoggedInViewController()
            }
        })
    }
    
//    private var currentView: UIView?
//    func refreshEquation() {
//        currentView?.removeFromSuperview()
//        if let view = equation.expression.generateView().view {
//            currentView = view
//            equationView?.addSubview(view)
//            view.center = CGPoint(x: 100.0, y: 200.0)
//        }
//
//    }
}

//extension TaskViewController: KeyboardManagerWillChangeFrameDelegate {
//    func keyboardManagerWillChangeKeyboardFrame(sender: KeyboardManager, from startFrame: CGRect, to endFrame: CGRect) {
//        mathKeyboardOpened = false
//        saveButtonHidden = false
//        //scrollViewBottomConstraint?.constant = self.view.bounds.height - self.view.convert(endFrame, to: nil).minY
//        self.view.layoutIfNeeded()
//        if titleTextField?.isFirstResponder == true {
//            //scrollView?.extras.scrollToViews([titleTextField])
//        } else if textView?.isFirstResponder == true {
//            //scrollView?.extras.scrollToViews([textView])
//        }
//
//    }
//}

extension TaskViewController: MathEquationViewControllerDelegate {
    func mathEquationViewController(sender: MathEquationViewController, didWriteEquation equation: Equation) {
        //self.equation = equation
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
        let height = equationsAndTexts[indexPath.row].expression.generateView().view?.frame.height ?? 44
        return height + 10
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }
    
//    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let equation = equationsAndTexts[sourceIndexPath.row]
//        equationsAndTexts.remove(at: sourceIndexPath.row)
//        equationsAndTexts.insert(equation, at: destinationIndexPath.row)
//    }
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
        let controller = R.storyboard.main.mathEquationViewController()!
        controller.delegate = self
        controller.equation = equationsAndTexts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

extension TaskViewController {
    private func addLongPressGestureRecogniser() {
        guard let equationsTableView = equationsTableView else { return }
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressGesture(sender:)))
        longPress.minimumPressDuration = 0.5
        equationsTableView.addGestureRecognizer(longPress)
    }
    
    @objc private func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        guard let equationsTableView = equationsTableView else { return }
        let locationInTableView = sender.location(in: equationsTableView)
        let currentIndexPath = equationsTableView.indexPathForRow(at: locationInTableView)
        
        if sender.state == .began {
            guard let currentIndexPath = currentIndexPath, let cell = equationsTableView.cellForRow(at: currentIndexPath) else { return }
            UISelectionFeedbackGenerator().selectionChanged()
            previousIndexPath = currentIndexPath
            cellAndTapDifference = locationInTableView.y - cell.center.y
            cellSnapshot = snapshotOfCell(inputView: cell, center: cell.center, alpha: 0.8)
            equationsTableView.addSubview(cellSnapshot)
            cell.isHidden = true
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                
                self.cellSnapshot.transform = self.cellSnapshot.transform.scaledBy(x: 1.05, y: 1.05)
                self.cellSnapshot.alpha = 0.80
                
            }, completion: nil )
            
        } else if sender.state == .changed {
            
            cellSnapshot.center.y = locationInTableView.y - cellAndTapDifference
            guard  let currentIndexPath = currentIndexPath, currentIndexPath != previousIndexPath else { return }
            let itemToMove = equationsAndTexts[previousIndexPath.row]
            equationsAndTexts.remove(at: previousIndexPath.row)
            equationsAndTexts.insert(itemToMove, at: currentIndexPath.row)
            
            equationsTableView.moveRow(at: previousIndexPath, to: currentIndexPath)
            self.previousIndexPath = currentIndexPath
            
        } else if sender.state == .ended  {
            guard let cell = equationsTableView.cellForRow(at: previousIndexPath) else { return }
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.cellSnapshot.center = cell.center
                self.cellSnapshot.transform = CGAffineTransform.identity
            }, completion: { (finished) -> Void in
                if finished {
                    cell.isHidden = false
                    cell.alpha = 1
                    self.cellSnapshot.removeFromSuperview()
                }
            })
        }
    }
    
    func snapshotOfCell(inputView: UIView, center: CGPoint, alpha: CGFloat) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cellSnapshot = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        cellSnapshot.center = center
        cellSnapshot.alpha = alpha
        return cellSnapshot
    }
}

