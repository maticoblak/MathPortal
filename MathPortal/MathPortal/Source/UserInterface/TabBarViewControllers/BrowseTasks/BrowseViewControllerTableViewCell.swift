//
//  BrowseViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class BrowseViewControllerTableViewCell: UITableViewCell {

    @IBOutlet private var cellBackgroundView: VerticalGradientFrameView?
    @IBOutlet private var taskTitleLabel: UILabel?

    private var fontSize: CGFloat { return cellIsSelected ? 18*0.8 : 18 }
    var cellIsSelected: Bool = false {
        didSet {
            cellBackgroundView?.lineWidth = cellIsSelected ? 0 : 3.5
            taskTitleLabel?.font =  taskTitleLabel?.font.withSize(fontSize)
        }
    }
    
    func setupCell(taskTitle: String?) {
        taskTitleLabel?.text = taskTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskTitleLabel?.textColor = Color.pink
        taskTitleLabel?.font =  taskTitleLabel?.font.withSize(fontSize)
        cellBackgroundView?.bottomColor = Color.darkBlue
        cellBackgroundView?.topColor = Color.lightGrey
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard cellIsSelected != selected else { return }
        cellIsSelected = selected
    }
}
