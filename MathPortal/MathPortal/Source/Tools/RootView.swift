//
//  DrawViewController.swift
//  MathPortal
//
//  Created by Petra Čačkov on 03/06/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class RootView: UIView {
    
    // init values
    private(set) var radicandHorizontalOffset: CGFloat = 0
    private(set) var rootIndexView: UIView = UIView(frame: .zero)
    private(set) var radicandView: UIView = UIView(frame: .zero)
    
    // computed values
    private var frameHeight: CGFloat?
    private var path: UIBezierPath?
    private var radicandViewXValue: CGFloat = 0
    private var frameWidth: CGFloat?
    
    private(set) var offset: CGFloat = 0
    
    // accessable vars
    var scale: CGFloat = 1
    var strokeColor: UIColor = UIColor.black
    
    init(rootIndex: UIView, theOtherView: UIView, radicandHorizontalOffset: CGFloat) {
        super.init(frame: .zero)
        self.radicandView = theOtherView
        self.rootIndexView = rootIndex
        self.radicandHorizontalOffset = radicandHorizontalOffset
        refresh()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func refresh() {
        setFrameHeightAndOffset()
        refreshPath()
        setUpFrame()
        addViews()
    }
    
    func setFrameHeightAndOffset() {
        var height = radicandView.frame.height + 8
        var newOffset = radicandHorizontalOffset + 4.5
        if rootIndexView.frame.height > newOffset {
            height += rootIndexView.frame.height - newOffset
            newOffset += rootIndexView.frame.height - newOffset + 2
        }
        frameHeight = height
        offset = newOffset
    }
    
    private func refreshPath() {
        guard let frameHeight = frameHeight else { return }
        let P1: CGPoint = CGPoint(x: 2, y: offset + 1.5/2)
        let P2: CGPoint = CGPoint(x: P1.x + rootIndexView.frame.width, y: P1.y)
        let P3: CGPoint = CGPoint(x: P2.x + 2.5, y: frameHeight - 4)
        let P4: CGPoint = CGPoint(x: P3.x + (2.5*frameHeight / (frameHeight - offset)), y: frameHeight - radicandView.frame.height - 4)
        let P5: CGPoint = CGPoint(x: P4.x + radicandView.frame.width + 2, y: P4.y)
        
        path = UIBezierPath()
        path?.move(to: P1)
        path?.addLine(to: P2)
        path?.addLine(to: P3)
        path?.addLine(to: P4)
        path?.addLine(to: P5)
        radicandViewXValue = P4.x
    }
    
    private func addViews() {
        rootIndexView.frame = CGRect(x: 2, y: offset - rootIndexView.frame.height - CGFloat(scale), width: rootIndexView.frame.width, height: rootIndexView.frame.height)
        radicandView.frame = CGRect(x: radicandViewXValue, y: offset - radicandHorizontalOffset, width: radicandView.frame.width, height: radicandView.frame.height)
        self.addSubview(rootIndexView)
        self.addSubview(radicandView)
    }
    private func setUpFrame() {
        frameWidth = radicandView.frame.width + radicandViewXValue + 4
        guard let frameWidth = frameWidth, let frameHeight = frameHeight else { return }
        self.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        strokeColor.setStroke()
        path?.lineWidth = 1.5 * scale
        path?.stroke()
    }
}


