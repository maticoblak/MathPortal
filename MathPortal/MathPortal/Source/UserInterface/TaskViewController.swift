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
    @IBOutlet private var textView: UITextView?
    @IBOutlet private var saveButton: UIButton?
    
    @IBOutlet private var titleAndTextView: UIView?
    @IBOutlet private var equationView: UIView?
    
    @IBOutlet private var keyboardHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var equationLabel: UILabel?
    
    @IBOutlet private var scrollView: UIScrollView?
    
    @IBOutlet private var scrollViewBottomConstraint: NSLayoutConstraint?
    
    @IBOutlet private var keyboardContentControllerView: ContentControllerView?
    
    private let equation: Equation = Equation()
    
    
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
            scrollViewBottomConstraint?.constant = height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            scrollView?.extras.scrollToViews([equationLabel])
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardManager.sharedInstance.willChangeFrameDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHeightConstraint?.constant = 0
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToLoggedInViewController))
        taskTitle = task.name
        titleTextField?.text = taskTitle ?? "Title"
        setUpDefaultKeyboard()
    }
    private func setUpDefaultKeyboard() {
        titleTextField?.extras.addToolbar(doneButton: (selector: #selector(self.dismissDefaultKeyboard), target: self))
        textView?.extras.addToolbar(doneButton: (selector: #selector(self.dismissDefaultKeyboard), target: self))
    }
    
    @objc func dismissDefaultKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func goToEquationViewController(_ sender: Any) {
        let controller = R.storyboard.main.mathEquationViewController()!
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
        task.save(completion: { (success, error) in
            loadingSpinner.dismissLoadingScreen()
            self.goToLoggedInViewController()
        })
    }
    
    private var currentView: UIView?
    func refreshEquation() {
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView() {
            currentView = view
            self.view.addSubview(view)
            view.center = CGPoint(x: 100.0, y: 200.0)
        }
        
    }
}

extension TaskViewController: KeyboardManagerWillChangeFrameDelegate {
    func keyboardManagerWillChangeKeyboardFrame(sender: KeyboardManager, from startFrame: CGRect, to endFrame: CGRect) {
        mathKeyboardOpened = false
        saveButtonHidden = false
        scrollViewBottomConstraint?.constant = self.view.bounds.height - self.view.convert(endFrame, to: nil).minY
        self.view.layoutIfNeeded()
        if titleTextField?.isFirstResponder == true {
            scrollView?.extras.scrollToViews([titleTextField])
        } else if textView?.isFirstResponder == true {
            scrollView?.extras.scrollToViews([textView])
        }
        
    }
}
