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
    
    @IBOutlet private var equationLabel: UILabel?
    
    @IBOutlet private var keyboardOpenConstraint: NSLayoutConstraint?
    
    @IBOutlet private var keyboardClosedConstraint: NSLayoutConstraint?
    
    @IBOutlet private var keyboardContentControllerView: ContentControllerView?
    
    
    var keyboardOpened: Bool = false {
        didSet {
            keyboardClosedConstraint?.isActive = !keyboardOpened
            keyboardOpenConstraint?.isActive = keyboardOpened
        }
    }
    var equationArray: [String] = ["|"] {
        didSet {
            equationLabel?.text = equationArray.compactMap({$0}).joined(separator: " ")
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
        
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToLoggedInViewController))
        taskTitle = task.name
        titleTextField?.text = taskTitle ?? "Title"
        
    }
    @IBAction func openCloseKeyboard(_ sender: Any) {
        keyboardOpened = !keyboardOpened
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func goToEditView(_ sender: Any) {
        let controller = R.storyboard.customKeyboard.customKeyboardViewController()!
        navigationController?.pushViewController(controller, animated: true)
    }
    var task: Task!
    var taskTitle: String?
    
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
    
    func handelKeyboardButtonsPressed(button: KeyboardButtons) {
        guard let index = equationArray.firstIndex(of: "|") else { return }
        switch button {
        case .one, .two, .three, .four, .plus, .minus:
            equationArray.insert(button.string, at: index)
        case .leftBracket, .rightBracket:
            equationArray.insert(button.string, at: index)
        case .back:
            guard index > 0 else { return }
            let coursor = equationArray.remove(at: index)
            equationArray.insert(coursor, at: index - 1)
        case .delete:
            guard index > 0 else { return }
            equationArray.remove(at: index - 1)
        case .levelUpArrow:
            return
        case .levelDownArrow:
            return
        case .front:
            guard index < equationArray.count - 1 else { return }
            let coursor = equationArray.remove(at: index)
            equationArray.insert(coursor, at: index + 1)
        }
        print(equationArray)
    }
}

extension TaskViewController: CustomKeyboardViewControllerDelegate {
    func customKeyboardViewController(sender: CustomKeyboardViewController, didChoseKey key: KeyboardButtons) {
        handelKeyboardButtonsPressed(button: key)
    }
}
