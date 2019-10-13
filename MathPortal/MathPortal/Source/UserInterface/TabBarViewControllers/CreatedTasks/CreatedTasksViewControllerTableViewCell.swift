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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskLabel?.textColor = UIColor.mathOrange
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
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
        gradientLayer = Appearence.getGradientLayerFor(taskView, colors: [.black])
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
