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
    
    @IBOutlet private var keyboardHeightConstraint: NSLayoutConstraint?
    @IBOutlet private var equationLabel: UILabel?
        
    @IBOutlet private var keyboardContentControllerView: ContentControllerView?
    
    var task: Task!
    var taskTitle: String?
    
    var mathKeyboardOpened: Bool = false {
        didSet {
            keyboardHeightConstraint?.constant = mathKeyboardOpened ? 280 : 0
        }
    }
    var equationArray: [Button] = [Button(key: .indicator)] {
        didSet {
            equationLabel?.text = equationArray.map {$0.keyName.string}.joined(separator: " ")
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(defaultKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.titleTextField?.inputAccessoryView = KeyboardManager.addDoneButton(selector: #selector(self.dismissDefaultKeyboard), target: self)
        self.textView?.inputAccessoryView = KeyboardManager.addDoneButton(selector: #selector(self.dismissDefaultKeyboard), target: self)
    }
    
    @objc func defaultKeyboardWillShow(notification: NSNotification) {
        mathKeyboardOpened = false
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissDefaultKeyboard() {
        view.endEditing(true)
    }
    @IBAction func openCloseMathKeyboard(_ sender: Any) {
        dismissDefaultKeyboard()
        mathKeyboardOpened = !mathKeyboardOpened
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
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
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        case .indicator:
            return
        }
    }
}

extension TaskViewController: CustomKeyboardViewControllerDelegate {
    func customKeyboardViewController(sender: CustomKeyboardViewController, didChoseKey key: Button.ButtonType) {
        handelMathKeyboardButtonsPressed(button: key)
    }
}
