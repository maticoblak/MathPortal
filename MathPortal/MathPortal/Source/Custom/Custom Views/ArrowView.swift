//
//  ArrowView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 26/12/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class ArrowView: UIView {

    private var fromView: EquationView = .Nil
    private var toView: EquationView = .Nil
    
    private lazy var arrowLength: CGFloat = { return  20 * scale }()
    private lazy var arrowTipFrame: CGRect = { return CGRect(x: 0, y: 0, width: 5*scale, height: 5*scale) }()
    
    private(set) var offset: CGFloat = 0
    private let spacing: CGFloat = 2
    
    var strokeColor: UIColor = .black
    var scale: CGFloat = 1
    
    init(from fromView: EquationView, to toView: EquationView, scale: CGFloat) {
        super.init(frame: .zero)
        self.fromView = fromView
        self.toView = toView
        self.offset = max(fromView.verticalOffset, toView.verticalOffset)
        self.scale = scale
        refresh()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refresh() {
        addViews()
        setNeedsDisplay()
    }
    
    private func drawArrow() {
        guard let fromViewBounds = fromView.view?.bounds else { return }
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: fromViewBounds.width + spacing , y: offset))
        arrowPath.addLine(to: CGPoint(x: fromViewBounds.width + arrowLength, y: offset))
        arrowPath.addLine(to: CGPoint(x: fromViewBounds.width + arrowLength - arrowTipFrame.width, y: offset - arrowTipFrame.height))
        arrowPath.move(to: CGPoint(x: fromViewBounds.width + arrowLength, y: offset))
        arrowPath.addLine(to: CGPoint(x: fromViewBounds.width + arrowLength - arrowTipFrame.width, y: offset + arrowTipFrame.height))
        
        strokeColor.setStroke()
        arrowPath.lineWidth = CGFloat(scale)
        arrowPath.stroke()
    }
    
    private func addViews() {
        [fromView.view, toView.view].forEach { $0?.removeFromSuperview() }
        guard let from = fromView.view, let to = toView.view else { return }
        from.frame.origin = CGPoint(x: 0, y: offset - fromView.verticalOffset)
        to.frame.origin = CGPoint(x: from.bounds.width + arrowLength + spacing, y: offset - toView.verticalOffset)
        [from, to].forEach { self.addSubview($0) }
        self.frame.size = CGSize(width: from.bounds.width + arrowLength + to.bounds.width + 2*spacing, height: max(from.frame.maxY, arrowTipFrame.height, to.frame.maxY))
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawArrow()
    }
}
