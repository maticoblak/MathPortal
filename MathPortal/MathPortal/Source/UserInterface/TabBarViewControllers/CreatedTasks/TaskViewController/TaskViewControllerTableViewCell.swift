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
    @IBOutlet var deleteLeadingConstraint: NSLayoutConstraint?
    @IBOutlet var deleteButtonShadow: UIView?
    @IBOutlet var deleteButtonView: UIView?
    
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
        //self.deleteViewClosed = true
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
            currentView = view
            equationView?.addSubview(view)
            view.frame.origin = CGPoint(x: 10, y: 5)
        }
    }

    private func setupGestureRecognisers() {
        //TODO: add long gesture rcogniser for reordering the cells
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipe))
        panGestureRecognizer?.delegate = self
        guard let panGestureRecognizer = panGestureRecognizer else { return }
        self.equationView?.addGestureRecognizer(panGestureRecognizer)
       
        tapGestureRecogniserDelete = UITapGestureRecognizer(target: self, action: #selector(deleteEquation))
        tapGestureRecogniserDelete?.delegate = self
        if let tapGestureRecogniserDelete = tapGestureRecogniserDelete {
            self.deleteButtonView?.addGestureRecognizer(tapGestureRecogniserDelete)
        }
        
        tapGestureRecogniserSelect = UITapGestureRecognizer(target: self, action: #selector(selectCell))
        tapGestureRecogniserSelect?.delegate = self
        if let tapGestureRecogniserSelect = tapGestureRecogniserSelect {
            self.equationView?.addGestureRecognizer(tapGestureRecogniserSelect)
        }
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
            } else { return false }
        } else if let tapGestureRecogniser = gestureRecognizer as? UITapGestureRecognizer {
            cellLocation = tapGestureRecogniser.location(in: superview)
            return true
        } else { return false }
    }
    
    private func moveOnSwipe() {
        guard let deleteLeadingConstraint = deleteLeadingConstraint, let deleteView = deleteView  else { return }
        let constraintConstatn = deleteLeadingConstraint.constant
        if constraintConstatn > deleteView.frame.width/2 {
            deleteViewClosed = false
        } else if constraintConstatn <= deleteView.frame.width/2 {
            deleteViewClosed = true
        }
    }
}


