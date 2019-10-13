//
//  BrowseViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class BrowseViewControllerTableViewCell: UITableViewCell {

    @IBOutlet private var cellView: UIView?
    @IBOutlet private var taskTitleLabel: UILabel?
    
    private var gradientLayer: CAGradientLayer?
    
    func setupCell(taskTitle: String?) {
        taskTitleLabel?.text = taskTitle
    }
    
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
}
