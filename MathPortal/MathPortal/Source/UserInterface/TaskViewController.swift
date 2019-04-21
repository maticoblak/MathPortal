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
    
    @IBOutlet private var editButton: UIButton?
    
    @IBOutlet private var keyboardContentControllerView: ContentControllerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardContentControllerView?.setViewController(controller: {
            let controller = R.storyboard.customKeyboard.customKeyboardViewController()!
            return controller
        }(), animationStyle: .fade)
        Appearence.addLeftBarButton(controller: self, leftBarButtonTitle: "< Back ", leftBarButtonAction: #selector(goToLoggedInViewController))
        taskTitle = task.name
        titleTextField?.text = taskTitle ?? "Title"
        
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
}
