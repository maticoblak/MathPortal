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
    
    @IBOutlet private var cellView: UIView?
    private var gradientLayer: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskTitleLabel?.textColor = UIColor.mathPink
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }
    
    var previousFrame: CGRect = .zero
    private func addGradient() {
        guard previousFrame != cellView?.frame else { return }
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = Appearence.getGradientLayerFor(cellView, colors: [.black])
        if let gradientLayer = gradientLayer {
            cellView?.layer.addSublayer(gradientLayer)
        }
        previousFrame = cellView?.frame ?? .zero
    }
    
    func setUpCell(taskName: String?) {
        if let taskName = taskName { taskTitleLabel?.text = taskName }
    }
}
