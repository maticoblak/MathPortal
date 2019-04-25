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
    
    var equationArray: [Button] = [Button(key: .indicator)] {
        didSet {
            equationLabel?.text = equationArray.map {$0.keyName.string}.joined(separator: " ")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardManager.sharedInstance.willChangeFrameDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Keyboard setup
        keyboardContentControllerView?.setViewController(controller: {
            let controller = R.storyboard.customKeyboard.customKeyboardViewController()!
            controller.delegate = self
            return controller
        }(), animationStyle: .fade)
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
    
    @IBAction func openCloseMathKeyboard(_ sender: Any) {
        keyboardWillClose = true
        dismissDefaultKeyboard()
        mathKeyboardOpened = !mathKeyboardOpened
    }
    @IBAction func goToEditView(_ sender: Any) {
        let controller = R.storyboard.customKeyboard.customKeyboardViewController()!
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
    
    func handelMathKeyboardButtonsPressed(button: Button.ButtonType) {
        guard let index = equationArray.firstIndex(where: {$0.name == Button.ButtonType.indicator.string}) else { return }
        switch button {
        case .integer, .plus, .minus, .leftBracket,.rightBracket:
            let key: Button = Button(key: button)
            equationArray.insert(key, at: index)
        case .brackets:
            let coursor = equationArray.remove(at: index)
            let leftBracket: Button = Button(key: Button.ButtonType.leftBracket)
            let rightBracket: Button = Button(key: Button.ButtonType.rightBracket)
            equationArray.insert(rightBracket, at: index)
            equationArray.insert(coursor, at: index)
            equationArray.insert(leftBracket, at: index)
        case .back:
            guard index > 0 else { return }
            let coursor = equationArray.remove(at: index)
            equationArray.insert(coursor, at: index - 1)
        case .delete:
            guard index > 0 else { return }
            equationArray.remove(at: index - 1)
        case .front:
            guard index < equationArray.count - 1 else { return }
            let coursor = equationArray.remove(at: index)
            equationArray.insert(coursor, at: index + 1)
        case .done:
            mathKeyboardOpened = false
            keyboardWillClose = false
        case .indicator:
            return
        }
    }
    var keyboardWillClose: Bool = false
}

extension TaskViewController: CustomKeyboardViewControllerDelegate {
    func customKeyboardViewController(sender: CustomKeyboardViewController, didChoseKey key: Button.ButtonType) {
        handelMathKeyboardButtonsPressed(button: key)
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
