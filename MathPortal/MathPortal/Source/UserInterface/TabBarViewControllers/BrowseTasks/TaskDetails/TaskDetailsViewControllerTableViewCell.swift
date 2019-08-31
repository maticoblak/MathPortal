//
//  TaskDetailsViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 24/08/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class TaskDetailsViewControllerTableViewCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var equationView: UIView?
    
    func setupCell(title: String? = nil, equation: Equation? = nil) {
        titleLabel?.text = title
        titleLabel?.backgroundColor = .clear
        guard let equation = equation, let view = equation.expression.generateView().view else { return }
        equationView?.addSubview(view)
        view.frame.origin = CGPoint(x: 10, y: 5)
    }
}
