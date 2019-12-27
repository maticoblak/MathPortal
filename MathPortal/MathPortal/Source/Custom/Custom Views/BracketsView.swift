//
//  BracketsView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 04/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit


class BracketsView: UIView {
    
    // init
    private(set) var viewInBrackets: UIView = UIView(frame: .zero)
    private(set) var viewHeight: CGFloat = 0
    private(set) var type: Equation.Component.BracketsType = .normal
    
    // computed
    private var path: UIBezierPath?
    private var viewWidth: CGFloat = 0
    private(set) var bracketWidth: CGFloat = 0
    
    // to set
    var strokeColor: UIColor = UIColor.black {
        didSet {
            refresh()
        }
    }
    var scale: CGFloat = 1 {
        didSet {
            refresh()
        }
    }

    init(viewInBrackets: UIView, type: Equation.Component.BracketsType = .normal) {
        super.init(frame: .zero)
        self.viewInBrackets = viewInBrackets
        self.viewHeight = viewInBrackets.bounds.height
        self.type = type
        refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func refresh() {
        refreshPath()
        addView()
        setUpFrame()
    }
    private func refreshPath() {
        switch type {
        case .absolute:
            bracketWidth = 5
            viewWidth = viewInBrackets.frame.width + 2*bracketWidth
            path = {
                let path = UIBezierPath(rect: CGRect(origin: CGPoint(x: bracketWidth, y: 0), size: CGSize(width: 0, height: 0)))
                path.addLine(to: CGPoint(x: bracketWidth, y: viewHeight))
                path.move(to: CGPoint(x: viewWidth - bracketWidth, y: 0))
                path.addLine(to: CGPoint(x: viewWidth - bracketWidth, y: viewHeight))
                return path
            }()
        case .normal:
            bracketWidth = viewInBrackets.frame.height / 4
            viewWidth = viewInBrackets.frame.width + 2*bracketWidth
            path = {
                let path = UIBezierPath(rect: CGRect(origin: CGPoint(x: bracketWidth, y: 0), size: CGSize(width: 0, height: 0)))
                path.addQuadCurve(to: CGPoint(x: bracketWidth, y: viewHeight), controlPoint: CGPoint(x: 0, y: viewHeight/2))
                path.move(to: CGPoint(x: viewWidth - bracketWidth, y: 0))
                path.addQuadCurve(to: CGPoint(x: viewWidth - bracketWidth, y: viewHeight), controlPoint: CGPoint(x: viewWidth, y: viewHeight/2))
                return path
            }()
        case .none:
            return
        }
    }
    private func addView() {
        viewInBrackets.frame = CGRect(origin: CGPoint(x: bracketWidth, y: 0), size: viewInBrackets.frame.size)
        self.addSubview(viewInBrackets)
    }
    
    private func setUpFrame() {
        self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        strokeColor.setStroke()
        path?.lineWidth = CGFloat(scale)
        path?.stroke()
    }
}


