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
    
    @IBOutlet private var cellView: VerticalGradientFrameView?
    
    private var fontSize: CGFloat { return cellIsSelected ? 18*0.8 : 18 }
    var cellIsSelected: Bool = false {
        didSet {
            cellView?.lineWidth  = cellIsSelected ? 0 : 3.5
            taskTitleLabel?.font =  taskTitleLabel?.font.withSize(fontSize)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView?.bottomColor = Color.darkBlue
        cellView?.topColor = Color.lightGrey
        taskTitleLabel?.textColor = Color.pink
        taskTitleLabel?.font =  taskTitleLabel?.font.withSize(fontSize)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard cellIsSelected != selected else { return }
        cellIsSelected = selected
    }
    
    func setUpCell(taskName: String?) {
        if let taskName = taskName { taskTitleLabel?.text = taskName }
    }
}
