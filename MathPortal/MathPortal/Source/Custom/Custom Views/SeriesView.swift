//
//  SeriesView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 04/01/2020.
//  Copyright © 2020 Petra Čačkov. All rights reserved.
//

import UIKit

class SeriesView: UIView {

    private var type: Equation.Series.SeriesType?
    private var baseView: EquationView?
    private var minView: EquationView?
    private var maxView: EquationView?
    private var scale: CGFloat?
    
    private var strokeColor: UIColor = .black
    private var path: UIBezierPath = UIBezierPath(rect: .zero)
    private var indent: (vertical: CGFloat, horizontal: CGFloat) = (1.0, 4)
    private lazy var symbolSize: CGSize = CGSize(width: 3*(baseView?.view?.bounds.height ?? 30)/4, height: (baseView?.view?.bounds.height ?? 30) + 2*indent.vertical)
    

    init(type: Equation.Series.SeriesType, scale: CGFloat, baseView: EquationView, minView: EquationView, maxView: EquationView, color: UIColor) {
        super.init(frame: .zero)
        self.type = type
        self.baseView = baseView
        self.minView = minView
        self.maxView = maxView
        self.scale = scale
        self.strokeColor = color
        refresh()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func refresh() {
        setupPath()
        setupViews()
    }
    
    private func setupPath() {
        guard let maxBound = maxView?.view, let minBound = minView?.view else { return }
        let horisontalOffset = symbolSize.width - max(maxBound.bounds.width, minBound.bounds.width)
        if horisontalOffset < 0 {
            indent.horizontal = -1 * horisontalOffset/2
        }
        
        switch type {
        case .sum:
            path.move(to: CGPoint(x: indent.horizontal + symbolSize.width, y: maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal, y: maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal + symbolSize.width/2, y: symbolSize.height/2 + maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal, y: symbolSize.height + maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal + symbolSize.width, y: symbolSize.height + maxBound.bounds.height + indent.vertical))
        case .product:
            path.move(to: CGPoint(x: indent.horizontal + symbolSize.width, y: maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal, y: maxBound.bounds.height + indent.vertical))
            path.move(to: CGPoint(x: indent.horizontal + symbolSize.width/3, y:  maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal + symbolSize.width/3, y: maxBound.bounds.height + indent.vertical + symbolSize.height))
            path.move(to: CGPoint(x: indent.horizontal + 2*symbolSize.width/3, y:  maxBound.bounds.height + indent.vertical))
            path.addLine(to: CGPoint(x: indent.horizontal + 2*symbolSize.width/3, y: maxBound.bounds.height + indent.vertical + symbolSize.height))
        case .none:
            return
        }
    }
    
    private func setupViews() {
        [baseView, maxView, minView].forEach { $0?.view?.removeFromSuperview() }
        guard let maxValueView = maxView?.view, let minValueView = minView?.view else { return }
        baseView?.view?.frame.origin = CGPoint(x: indent.horizontal + symbolSize.width, y: indent.vertical + maxValueView.bounds.height + symbolSize.height/2 - (baseView?.view?.bounds.height ?? 0)/2)
        maxValueView.frame.origin = CGPoint(x: indent.horizontal + symbolSize.width/2 - maxValueView.bounds.width/2, y: 0)
        minValueView.frame.origin = CGPoint(x: indent.horizontal + symbolSize.width/2 - minValueView.bounds.width/2, y: symbolSize.height + maxValueView.bounds.height + 2*indent.vertical)
        let frameWidth = max(indent.horizontal + symbolSize.width + (baseView?.view?.bounds.width ?? 0), maxValueView.bounds.width, minValueView.bounds.width)
        self.frame.size = CGSize(width: frameWidth, height: symbolSize.height + minValueView.bounds.height + maxValueView.bounds.height + 2*indent.vertical)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.clear
        [baseView, maxView, minView].forEach { self.addSubview($0?.view ?? UIView()) }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        strokeColor.setStroke()
        path.lineWidth = 2*(scale ?? 1)
        path.stroke()
        
    }
    
}
