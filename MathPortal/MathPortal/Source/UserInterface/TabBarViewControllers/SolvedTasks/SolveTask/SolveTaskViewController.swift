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
    @IBOutlet private var answerContentController: ContentControllerView?
    
    var user: User!
    var task: Task!
    override func viewDidLoad() {
        super.viewDidLoad()

        taskContentController?.setViewController(controller: {
            let controller = R.storyboard.browseTasksViewController.taskDetailsViewController()
            controller?.user = user
            controller?.task = task
            return controller
        }(), animationStyle: .fade)
        
        answerContentController?.setViewController(controller: {
            let controller = R.storyboard.main.taskViewController()
            controller?.task = Task()
            return controller
        }(), animationStyle: .fade)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
