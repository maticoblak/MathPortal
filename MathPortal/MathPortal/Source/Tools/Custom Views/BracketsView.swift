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

    init(viewInBrackets: UIView) {
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
        bracketWidth = viewInBrackets.frame.height / 5
        viewWidth = viewInBrackets.frame.width + 2*bracketWidth
        path = UIBezierPath(rect: CGRect(origin: CGPoint(x: bracketWidth, y: 0), size: CGSize(width: 0, height: 0)))
        path?.addCurve(to: CGPoint(x: bracketWidth, y: viewHeight) , controlPoint1: CGPoint(x: 0, y: viewHeight/4), controlPoint2: CGPoint(x: 0, y: 3*viewHeight/4))
        path?.move(to: CGPoint(x: viewWidth - bracketWidth, y: 0))
        path?.addCurve(to: CGPoint(x: viewWidth - bracketWidth, y: viewHeight), controlPoint1: CGPoint(x: viewWidth, y: viewHeight/4), controlPoint2: CGPoint(x: viewWidth, y: 3*viewHeight/4))
        
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
        strokeColor.setStroke()
        path?.lineWidth = CGFloat(scale)
        path?.stroke()
    }
}
