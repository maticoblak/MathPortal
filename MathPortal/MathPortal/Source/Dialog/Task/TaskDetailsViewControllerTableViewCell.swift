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
    
    private var currentExpressionView: UIView?
    
    func setupTitle(_ title: String?) {
        guard let title = title else { return }
        titleLabel?.text = title
        titleLabel?.backgroundColor = .clear
        currentExpressionView?.removeFromSuperview()
        currentExpressionView = nil
    }
    
    func setupEquationView(_ expressionView: UIView?) {
        currentExpressionView?.removeFromSuperview()
        titleLabel?.text = nil
        
        currentExpressionView = nil
        guard let equationView = equationView, let expressionView = expressionView else { return }
        
        equationView.addSubview(expressionView)
        expressionView.translatesAutoresizingMaskIntoConstraints = false
        equationView.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .leading, relatedBy: .equal, toItem: equationView, attribute: .leading, multiplier: 1.0, constant: 10))
        equationView.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .trailing, relatedBy: .equal, toItem: equationView, attribute: .trailing, multiplier: 1.0, constant: 10))
        equationView.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .top, relatedBy: .equal, toItem: equationView, attribute: .top, multiplier: 1.0, constant: 5))
        equationView.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .bottom, relatedBy: .equal, toItem: equationView, attribute: .bottom, multiplier: 1.0, constant: 5))
        
         currentExpressionView = expressionView
    }
}
