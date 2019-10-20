//
//  GradientView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 14/10/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

@IBDesignable class VerticalGradientFrameView: UIView {
    
    @IBInspectable var topColor: UIColor? = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var bottomColor: UIColor? = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), let topColor = topColor, let bottomColor = bottomColor else { return }
        
        context.saveGState()
        
        context.setLineWidth(lineWidth)
        context.addPath(UIBezierPath(rect: rect.insetBy(dx: lineWidth*0.5, dy: lineWidth*0.5)).cgPath)
        context.replacePathWithStrokedPath()
        context.clip()
        
        let locations: [CGFloat] = [0.0, 1.0]
        let colors = [topColor.cgColor, bottomColor.cgColor]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations) {
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint( x: 0.0, y: frame.size.height), options: CGGradientDrawingOptions(rawValue: 0))
        }
        context.restoreGState()
    }
}

@IBDesignable class HorizontalGradientView: UIView {
    
    @IBInspectable var leftColor: UIColor? = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var rightColor: UIColor? = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), let leftColor = leftColor, let rightColor = rightColor else { return }
        
        context.saveGState()

        let locations: [CGFloat] = [0.0, 1.0]
        let colors = [leftColor.cgColor, rightColor.cgColor]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locations) {
            context.drawLinearGradient(gradient, start: .zero, end: CGPoint( x: frame.size.width, y: 0.0), options: CGGradientDrawingOptions(rawValue: 0))
        }
        context.restoreGState()
    }
}

