//
//  TaskViewControllerTableViewCell.swift
//  MathPortal
//
//  Created by Petra Čačkov on 28/07/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

protocol TaskViewControllerTableViewCellDelegate: class {
    func taskViewControllerTableViewCell(sender: TaskViewControllerTableViewCell, didDeleteCellAt location: CGPoint)
    func taskViewControllerTableViewCell(sender: TaskViewControllerTableViewCell, didSelectCellAt location: CGPoint)
}

class TaskViewControllerTableViewCell: UITableViewCell {
    
    var equation: Equation?

    @IBOutlet private var deleteView: UIView?
    @IBOutlet private var equationView: UIView?
    @IBOutlet private var deleteLeadingConstraint: NSLayoutConstraint?
    @IBOutlet private var deleteButtonShadow: UIView?
    @IBOutlet private var deleteButtonView: UIView?
    
    weak var delegate: TaskViewControllerTableViewCellDelegate?
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var tapGestureRecogniserDelete: UITapGestureRecognizer?
    private var tapGestureRecogniserSelect: UITapGestureRecognizer?
    private var cellLocation: CGPoint?
    
    private var deleteViewClosed: Bool = true {
        didSet {
            guard let deleteView = deleteView else { return }
            deleteLeadingConstraint?.constant = deleteViewClosed ? 0 : deleteView.frame.width
            UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteViewClosed = true
        if let deleteButtonShadow = deleteButtonShadow, let deleteButtonView = deleteButtonView {
            deleteButtonView.layer.cornerRadius = deleteButtonView.frame.width/2
            deleteButtonShadow.layer.cornerRadius = deleteButtonShadow.frame.width/2
        }
        setupGestureRecognisers()
    }
    
    func setupCell(delegate: TaskViewControllerTableViewCellDelegate, equation: Equation) {
        self.selectionStyle = .none
        self.showsReorderControl = false
        self.delegate = delegate
        self.equation = equation
        refreshEquation()
    }
    
    private var currentView: UIView?
    private func refreshEquation() {
        guard let equation = equation else { return }
        currentView?.removeFromSuperview()
        if let view = equation.expression.generateView().view {
            equationView?.addSubview(view)
            addConstraints(view)
            currentView = view
        }
    }
    
    private func addConstraints(_ expressionView: UIView) {
        expressionView.translatesAutoresizingMaskIntoConstraints = false
        equationView?.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .leading, relatedBy: .equal, toItem: equationView, attribute: .leading, multiplier: 1.0, constant: 10))
        equationView?.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .trailing, relatedBy: .equal, toItem: equationView, attribute: .trailing, multiplier: 1.0, constant: -10))
        equationView?.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .top, relatedBy: .equal, toItem: equationView, attribute: .top, multiplier: 1.0, constant: 5))
        equationView?.addConstraint(NSLayoutConstraint(item: expressionView, attribute: .bottom, relatedBy: .equal, toItem: equationView, attribute: .bottom, multiplier: 1.0, constant: -5))
    }

    private func setupGestureRecognisers() {
        panGestureRecognizer = {
            let recogniser = UIPanGestureRecognizer(target: self, action: #selector(swipe))
            recogniser.delegate = self
            self.equationView?.addGestureRecognizer(recogniser)
            return recogniser
        }()
        
        tapGestureRecogniserDelete = {
            let recogniser = UITapGestureRecognizer(target: self, action: #selector(deleteEquation))
            recogniser.delegate = self
            self.deleteButtonView?.addGestureRecognizer(recogniser)
            return recogniser
        }()
        
        tapGestureRecogniserSelect = {
            let recogniser = UITapGestureRecognizer(target: self, action: #selector(selectCell))
            recogniser.delegate = self
            self.equationView?.addGestureRecognizer(recogniser)
            return recogniser
        }()
    }
    
    @objc private func deleteEquation(sender: UITapGestureRecognizer) {
        guard let cellLocation = cellLocation else { return }
        deleteViewClosed = true
        delegate?.taskViewControllerTableViewCell(sender: self, didDeleteCellAt: cellLocation )
    }
    
    @objc private func selectCell(sender: UITapGestureRecognizer) {
        guard let cellLocation = cellLocation else { return }
        deleteViewClosed = true
        delegate?.taskViewControllerTableViewCell(sender: self, didSelectCellAt: cellLocation)
    }
    
    private var previousLocation: CGPoint = .zero
    @objc private func swipe(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: self)

        switch sender.state {
        case .began:
            previousLocation = location
        case .changed:
            let distance: CGFloat = location.x - previousLocation.x
            deleteLeadingConstraint?.constant += distance
            previousLocation = location
        case .ended, .failed, .cancelled, .possible:
            moveOnSwipe()
        }
        
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecogniser = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecogniser.translation(in: self.contentView)
            if abs(translation.x) > abs(translation.y) {
                cellLocation = panGestureRecogniser.location(in: superview)
                return true
            } else {
                return false
            }
        } else if let tapGestureRecogniser = gestureRecognizer as? UITapGestureRecognizer {
            cellLocation = tapGestureRecogniser.location(in: superview)
            return true
        } else {
            return false
        }
    }
    
    private func moveOnSwipe() {
        guard let deleteLeadingConstraint = deleteLeadingConstraint, let deleteView = deleteView  else { return }
        let constraintConstant = deleteLeadingConstraint.constant
        if constraintConstant > deleteView.frame.width/2 {
            deleteViewClosed = false
        } else if constraintConstant <= deleteView.frame.width/2 {
            deleteViewClosed = true
        }
    }
}


