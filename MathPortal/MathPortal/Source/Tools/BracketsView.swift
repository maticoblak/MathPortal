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
    
    // computed
    private var path: UIBezierPath?
    private var viewHeight: CGFloat = 0
    private var viewWidth: CGFloat = 0
    private(set) var bracketWidth: CGFloat = 0
    
    // to set
    var strokeColor: UIColor = UIColor.black
    var scale: Double = 1
    
    
    init( viewInBrackets: UIView) {
        super.init(frame: .zero)
        self.viewInBrackets = viewInBrackets
        self.viewHeight = viewInBrackets.bounds.height
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
    
        let constant: CGFloat = 1.73 // cot30
        let centerFromSubview = viewHeight/2 * constant
        let radiousSquared = pow(viewHeight/2, 2) + pow(centerFromSubview, 2)
        let radious = pow(radiousSquared, 1/2)
        bracketWidth = radious - centerFromSubview
        viewWidth = 2*bracketWidth + viewInBrackets.frame.width + 4
        
        path = UIBezierPath(arcCenter: CGPoint(x: radious + 2, y: viewHeight/2), radius: radious, startAngle: 5*CGFloat.pi/6, endAngle: -5*CGFloat.pi/6, clockwise: true)
        path?.move(to: CGPoint(x: viewWidth - bracketWidth - 2, y: viewHeight))
        path?.addArc(withCenter: CGPoint(x: viewWidth - radious - 2, y: viewHeight/2), radius: radious, startAngle: CGFloat.pi/6, endAngle: -CGFloat.pi/6, clockwise: false)
    }
    private func addView() {
        viewInBrackets.frame = CGRect(origin: CGPoint(x: bracketWidth + 2, y: 0), size: viewInBrackets.frame.size)
        self.addSubview(viewInBrackets)
    }
    private func setUpFrame() {

        self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        path?.lineWidth = CGFloat(scale)
        path?.stroke()
    }
}
