//
//  TaskViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 28/07/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TaskViewControllerTableViewCell: UITableViewCell {
    
    var equation: Equation?

    @IBOutlet var equationView: UIView?
    override func awakeFromNib() {
        super.awakeFromNib()
        //refreshEquation()
    }
    
    private var currentView: UIView?
    func refreshEquation() {
        guard let equation = equation else { return }
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView().view {
            currentView = view
            equationView?.addSubview(view)
            view.frame.origin = .zero
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
