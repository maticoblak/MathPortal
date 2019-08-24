//
//  BrowseViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class BrowseViewControllerTableViewCell: UITableViewCell {

    @IBOutlet private var taskTitleLabel: UILabel?
 
    func setupCell(taskTitle: String?) {
        taskTitleLabel?.text = taskTitle
    }
}
