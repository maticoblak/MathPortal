//
//  TaskDetailsViewControllerSolutionCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 30/09/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TaskDetailsViewControllerSolutionCell: UITableViewCell {

    @IBOutlet private var solutionView: SolutionView?
    
    func setupCell(solution: TaskSolution?) {
        guard let solution = solution else { return }
        solutionView?.setupView(solution: solution)
        solutionView?.layer.borderWidth = 2
        solutionView?.layer.borderColor = Color.darkBlue.cgColor
        contentView.backgroundColor = Color.pink
    }
}
