//
//  SolutionView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 03/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class SolutionView: UIView {

    private var ownersUsername: UILabel = UILabel()
    private var ownersProfileImageView: UIImageView = UIImageView()
    private var equationViewsHeight: CGFloat = 0
    
    var owner: User?
    var solution: TaskSolution?
    var viewWidth: CGFloat?
    
    init(owner: User?, solution: TaskSolution?, width: CGFloat) {
        super.init(frame: .zero)
        self.owner = owner
        self.solution = solution
        self.viewWidth = width
        refresh()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func refresh() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        addViews()
        addProfileInfo()
        setupFrame()
    }
    
    private func addViews() {
        var yPosition: CGFloat = 0
        let xPosition: CGFloat = 10
        solution?.equations?.forEach { equation in
            guard let equationView = equation.expression.generateView().view else { return }
            equationView.frame.origin = CGPoint(x: xPosition, y: yPosition)
            yPosition += equationView.bounds.height
            self.addSubview(equationView)
        }
        equationViewsHeight = yPosition
    }
    
    private func addProfileInfo() {
        ownersProfileImageView.frame = CGRect(x: 0, y: equationViewsHeight, width: 60, height: 60)
        ownersProfileImageView.image = owner?.profileImage
        
        ownersUsername.text = owner?.username
        ownersUsername.textColor = .black
        ownersUsername.sizeToFit()
        ownersUsername.center = CGPoint(x: ownersProfileImageView.bounds.width + 20, y: equationViewsHeight + ownersProfileImageView.bounds.height/2)
        
        
        self.addSubview(ownersUsername)
        self.addSubview(ownersProfileImageView)
        
    }
    
    private func setupFrame() {
        self.frame.size = CGSize(width: viewWidth ?? 0, height:  equationViewsHeight + ownersProfileImageView.bounds.height)
        self.backgroundColor = .white
        self.setNeedsLayout()
    }
}
