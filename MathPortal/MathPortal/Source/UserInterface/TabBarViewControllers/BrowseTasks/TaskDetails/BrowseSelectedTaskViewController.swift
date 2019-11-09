//
//  BrowseSelectedTaskViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 30/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class BrowseSelectedTaskViewController: UIViewController {

    var task: Task!
    var solutions: [TaskSolution]?
    
    @IBOutlet private var taskContentControllerView: ContentControllerView?
    @IBOutlet private var solutionsTableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()

        taskContentControllerView?.setViewController(controller: {
            let controller = R.storyboard.taskDetailsViewController.taskDetailsViewController()
            controller?.task = task
            return controller
        }(), animationStyle: .fade)
        
        Appearence.setUpnavigationBar(controller: self, leftBarButtonTitle: "< Back", leftBarButtonAction: #selector(goBack), rightBarButtonTitle: "Solve", rightBarButtonAction: #selector(goToSolveScreen))
        
        solutionsTableView?.register(R.nib.taskDetailsViewControllerSolutionCell)
        // NOTE: Also works without setting rowHeight to UITableView.automaticDimension
        solutionsTableView?.rowHeight = UITableView.automaticDimension
        fechTaskSolutions()

    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToSolveScreen() {
        guard let user = User.current else { return }
        let loadingSpinner = LoadingViewController.showInNewWindow(text: "Saving")
        user.addToSavedTasks(task) { (success, error) in
            loadingSpinner.dismissFromCurrentWindow()
            if success {
                //TODO: go to solve task screen
            } else if let error = error {
                print(error)
            }
        }
    }
    
    private func fechTaskSolutions() {
        task.fetchSolutions { (solutions, error) in
            if let solutions = solutions {
                self.solutions = solutions
                self.solutionsTableView?.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }

}


extension BrowseSelectedTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solutions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.taskDetailsViewControllerSolutionCell, for: indexPath)!
        cell.setupCell(solution: solutions?[indexPath.row])
        return cell
    }
}
