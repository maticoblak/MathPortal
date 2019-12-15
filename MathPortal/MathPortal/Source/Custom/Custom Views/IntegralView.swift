//
//  IntegralView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 15/12/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class IntegralView: UIView {

    // init values
    private(set) var baseView: UIView = UIView(frame: .zero)
    private(set) var viewHeight: CGFloat = 0


   // computed
    private var path: UIBezierPath?
    private var viewWidth: CGFloat = 0
    private(set) var integralWidth: CGFloat = 10
    private(set) var capHeight: CGFloat = 10
    
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
    
    init(base: UIView) {
        super.init(frame: .zero)
        self.baseView = base
        self.viewHeight = base.bounds.height + capHeight*2
        viewWidth = baseView.frame.width + integralWidth
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

        path = {
            let path = UIBezierPath(rect: CGRect(origin: CGPoint(x: integralWidth, y: capHeight), size: CGSize(width: 0, height: 0)))
            path.addQuadCurve(to: CGPoint(x: integralWidth/2, y: capHeight), controlPoint: CGPoint(x: integralWidth - integralWidth/4 - 2, y: 0))
            path.addLine(to: CGPoint(x: integralWidth/2, y: viewHeight - capHeight))
            path.addQuadCurve(to: CGPoint(x: 0, y: viewHeight - capHeight), controlPoint: CGPoint(x: integralWidth/4 + 2, y: viewHeight))
            return path
        }()
    }
    private func addView() {
        baseView.frame = CGRect(origin: CGPoint(x: integralWidth, y: viewHeight/2 - baseView.bounds.height/2), size: baseView.frame.size)
        self.addSubview(baseView)
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
