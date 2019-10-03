//
//  SolvedTasksViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 25/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolvedTasksViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet private var taskTitleLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(taskName: String?) {
        if let taskName = taskName { taskTitleLabel?.text = taskName }
    }
}
