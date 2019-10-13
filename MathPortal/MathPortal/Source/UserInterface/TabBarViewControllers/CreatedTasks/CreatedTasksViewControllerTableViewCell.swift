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
    @IBOutlet private var taskView: UIView?
    private var gradientLayer: CAGradientLayer?
    private var fontSize: CGFloat { return cellIsSelected ? 18*0.8 : 18 }
    var cellIsSelected: Bool = false {
        didSet {
            gradientLayer?.isHidden = cellIsSelected
            taskLabel?.font =  taskLabel?.font.withSize(fontSize)
            updatedAtLabel?.font = updatedAtLabel?.font.withSize(fontSize*0.8)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskLabel?.textColor = UIColor.mathOrange
        taskLabel?.font =  taskLabel?.font.withSize(fontSize)
        updatedAtLabel?.font = updatedAtLabel?.font.withSize(fontSize*0.8)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
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
    var previousFrame: CGRect = .zero
    private func addGradient() {
        guard previousFrame != taskView?.frame else { return }
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = Appearence.getGradientLayerFor(taskView, colors: [UIColor.mathLightGrey.cgColor,UIColor.mathDarkBlue.cgColor])
        if let gradientLayer = gradientLayer {
            taskView?.layer.addSublayer(gradientLayer)
        }
        previousFrame = taskView?.frame ?? .zero
    }
    
    func refresh() {
        
        if let task = task {
            self.taskLabel?.text = task.name
            self.updatedAtLabel?.text = DateTools.stringFromDate(date: task.updatedAt)
        }
    }
    
}
