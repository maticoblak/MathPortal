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
    private(set) var viewWidth: CGFloat = 0
    var verticalOffset: CGFloat = 0

   // compute
    private var integralWidth: CGFloat = 10
    private var capHeight: CGFloat = 10
    
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
    
    init(base: UIView, verticalOffset: CGFloat) {
        super.init(frame: .zero)
        self.baseView = base
        self.viewHeight = base.bounds.height + capHeight*2
        self.viewWidth = baseView.frame.width + integralWidth
        self.verticalOffset = verticalOffset + capHeight
        refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     private func refresh() {
        addView()
        setUpFrame()
        setNeedsDisplay()
    }
    private func drawIntegral() {

        let path = UIBezierPath(rect: CGRect(origin: CGPoint(x: integralWidth, y: capHeight), size: CGSize(width: 0, height: 0)))
        path.addQuadCurve(to: CGPoint(x: integralWidth/2, y: capHeight), controlPoint: CGPoint(x: integralWidth - integralWidth/4 - 2, y: 0))
        path.addLine(to: CGPoint(x: integralWidth/2, y: viewHeight - capHeight))
        path.addQuadCurve(to: CGPoint(x: 0, y: viewHeight - capHeight), controlPoint: CGPoint(x: integralWidth/4 + 2, y: viewHeight))
        
        strokeColor.setStroke()
        path.lineWidth = CGFloat(scale)
        path.stroke()
        
    }
    private func addView() {
        baseView.frame = CGRect(origin: CGPoint(x: integralWidth, y: viewHeight/2 - baseView.bounds.height/2), size: baseView.frame.size)
        self.addSubview(baseView)
    }
    
    private func setUpFrame() {
        self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawIntegral()
        
    }
}
