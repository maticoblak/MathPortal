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
    private var fontSize: CGFloat { return cellIsSelected ? 18*0.8 : 18 }
    var cellIsSelected: Bool = false {
        didSet {
            gradientLayer?.isHidden = cellIsSelected
            taskTitleLabel?.font =  taskTitleLabel?.font.withSize(fontSize)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskTitleLabel?.textColor = UIColor.mathPink
        taskTitleLabel?.font =  taskTitleLabel?.font.withSize(fontSize)
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
    
    var previousFrame: CGRect = .zero
    private func addGradient() {
        guard previousFrame != cellView?.frame else { return }
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = Appearence.getGradientLayerFor(cellView, colors: [UIColor.mathLightGrey.cgColor,UIColor.mathDarkBlue.cgColor])
        if let gradientLayer = gradientLayer {
            cellView?.layer.addSublayer(gradientLayer)
        }
        previousFrame = cellView?.frame ?? .zero
    }
    
    func setUpCell(taskName: String?) {
        if let taskName = taskName { taskTitleLabel?.text = taskName }
    }
}
