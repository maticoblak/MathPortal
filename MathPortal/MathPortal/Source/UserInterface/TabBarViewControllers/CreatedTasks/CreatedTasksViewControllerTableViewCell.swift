//
//  CreatedTasksViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class CreatedTasksViewControllerTableViewCell: UITableViewCell {
    
    
    @IBOutlet private var taskLabel: UILabel?
    @IBOutlet private var updatedAtLabel: UILabel?
    @IBOutlet private var taskBackgroundView: VerticalGradientFrameView?
    private var fontSize: CGFloat { return cellIsSelected ? 18*0.8 : 18 }
    
    var cellIsSelected: Bool = false {
        didSet {
            taskLabel?.font =  taskLabel?.font.withSize(fontSize)
            updatedAtLabel?.font = updatedAtLabel?.font.withSize(fontSize*0.8)
            taskBackgroundView?.lineWidth = cellIsSelected ? 0 : 3.5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskLabel?.textColor = Color.orange
        taskLabel?.font =  taskLabel?.font.withSize(fontSize)
        updatedAtLabel?.font = updatedAtLabel?.font.withSize(fontSize*0.8)
        taskBackgroundView?.bottomColor = Color.darkBlue
        taskBackgroundView?.topColor = Color.lightGrey
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard cellIsSelected != selected else { return }
        cellIsSelected = selected
    }
    
    var task: Task? {
        didSet {
            refresh()
        }
    }
    
    func refresh() {
        if let task = task {
            self.taskLabel?.text = task.name
            self.updatedAtLabel?.text = DateTools.stringFromDate(date: task.updatedAt)
        }
    }
    
}
