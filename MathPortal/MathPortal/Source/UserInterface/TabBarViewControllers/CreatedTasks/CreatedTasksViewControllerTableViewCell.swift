//
//  CreatedTasksViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class CreatedTasksViewControllerTableViewCell: UITableViewCell {
    
    
    @IBOutlet private var taskLabel: UILabel?

    var task: Task? {
        didSet {
            refresh()
        }
    }
    
    func refresh() {
        if let task = task {
            self.taskLabel?.text = task.name
        }
    }
    
}
