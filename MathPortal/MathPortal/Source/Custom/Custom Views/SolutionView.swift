//
//  SolutionView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 03/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolutionView: UIView {
    
    private(set) var solution: TaskSolution?
    private var equationViewsHeight: CGFloat = 0
    private var ownerInfoViewHeight: CGFloat = 60
    private var myViews: [UIView] = [UIView]()
    
    lazy private var usernameLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    lazy private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    override var intrinsicContentSize: CGSize {
        // NOTE: 2 is just a placeholder since cell already has width
        return CGSize(width: 2, height: equationViewsHeight + ownerInfoViewHeight)
    }
    
    func setupView(solution: TaskSolution) {
        self.solution = solution
        removeSubviews()
        addViews()
        setupFrame()
        fetchSolutionOwner(solution: solution)
        self.invalidateIntrinsicContentSize()
    }
    
    private func addExpressionSubview(_ view: UIView) {
        self.addSubview(view)
        myViews.append(view)
    }
    
    private func removeSubviews() {
        myViews.forEach { $0.removeFromSuperview() }
        profileImageView.image = nil
        usernameLabel.text = nil
        myViews = []
    }
    
    private func fetchSolutionOwner(solution: TaskSolution) {
        solution.fetchSolutionOwner { (owner, error) in
            guard self.solution?.objectId == solution.objectId else { return }
            if let owner = owner {
                self.addProfileInfo(owner)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    private func addViews() {
        var yPosition: CGFloat = 10
        let xPosition: CGFloat = 10
        solution?.equations?.forEach { equation in
            guard let equationView = equation.expression.generateView().view else { return }
            equationView.frame.origin = CGPoint(x: xPosition, y: yPosition)
            yPosition += equationView.bounds.height + 10
            addExpressionSubview(equationView)
           
        }
        equationViewsHeight = yPosition
    }
    
    private func addProfileInfo(_ owner: User) {

        profileImageView.frame = CGRect(x: 0, y: equationViewsHeight, width: ownerInfoViewHeight, height: ownerInfoViewHeight)
        profileImageView.image = owner.profileImage
        
        usernameLabel.text = owner.username
        usernameLabel.textColor = .black
        usernameLabel.sizeToFit()
        usernameLabel.center = CGPoint(x: profileImageView.frame.maxX + 20, y: profileImageView.frame.origin.y + profileImageView.bounds.height/2)
    }
    
    private func setupFrame() {
        self.layer.cornerRadius = 5
    }
}
