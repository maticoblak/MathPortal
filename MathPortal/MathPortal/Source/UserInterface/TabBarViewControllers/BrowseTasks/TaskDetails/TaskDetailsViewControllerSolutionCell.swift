//
//  TaskDetailsViewControllerSolutionCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 30/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TaskDetailsViewControllerSolutionCell: UITableViewCell {

    @IBOutlet private var solutionView: UIView?
    
    private var solution: TaskSolution?
    private var owner: User?
    
    private func fetchAndSetSolutionOwner() {
        solution?.fetchSolutionOwner { (owner, error) in
            if let owner = owner {
                self.owner = owner
            } else {
                print(error?.localizedDescription)
            }
            self.setupEquationView()
        }
    }
    
    func setupCell(solution: TaskSolution?) {
        self.solution = solution
        fetchAndSetSolutionOwner()
    }
    
    func setupEquationView() {
        let equationView = SolutionView(owner: owner, solution: solution, width: self.bounds.width)
        solutionView?.addSubview(equationView)
        solutionView?.frame.size = equationView.frame.size
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
}
