//
//  EquationView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 21/05/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class EquationView {
    
    var view: UIView?
    var horizontalOffset: CGFloat
    var type: ExpressionType
    
    static let Nil = EquationView(view: nil, type: nil )
    
    init(view: UIView?, horizontalOffset: CGFloat, type: ExpressionType) {
        self.view = view
        self.horizontalOffset = horizontalOffset
        self.type = type
    }
    init(view: UIView?, type: ExpressionType?) {
        if let view = view, let type = type {
            self.view = view
            self.horizontalOffset = view.bounds.height*0.5
            self.type = type
        } else {
            self.horizontalOffset = 0.0
            self.type = .other
        }
    }
    enum ExpressionType {
        case text
        case mathOperator
        case brackets
        case component
        case fraction
        case root
        case index
        case exponent
        case indexAndExponent
        case other
    }
    
    static func linearlyLayoutViews(_ inputViews: [EquationView], type: ExpressionType, selectedColor: UIColor = Equation.defaultColor, brackets: Bool, color: UIColor = UIColor.black, scale: CGFloat) -> EquationView {
        let equationViews: [EquationView] = inputViews
        
        let views: [UIView] = inputViews.compactMap { $0.view }
        guard views.count > 0 else { return .Nil }
        
        let heightOffset = linearComponentHiightAndOffset(inputViews: equationViews)
        
        var newView = UIView(frame: .zero)
        var x: CGFloat = 0.0
        
        equationViews.forEach { item in
            guard let view = item.view else { return }
            view.frame.origin.x = x
            view.frame.origin.y = heightOffset.offset - item.horizontalOffset
            newView.addSubview(view)
            
            x += view.bounds.width
        }
        newView.frame = CGRect(x: 0.0, y: 0.0, width: x, height: heightOffset.height)
        var currentType: ExpressionType = type
        if brackets {
            currentType = .brackets
            addBrackets(to: &newView, withScale: scale, andColor: color)
        }
        
        newView.backgroundColor = selectedColor
        newView.layer.cornerRadius = 5
        return EquationView(view: newView, horizontalOffset: heightOffset.offset, type: currentType)
    }
}


// MARK: - Expresson views
extension EquationView {
    
    static func generateOperator(_ operatorType: Equation.Operator.OperatorType, colour: UIColor, scale: CGFloat) -> EquationView {
        let label = UILabel(frame: .zero)
        label.text = {
            switch operatorType {
            case .plus: return "+"
            case .minus: return "-"
            }
        }()
        label.backgroundColor = colour
        label.font = label.font.withSize(17*CGFloat(scale))
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label, type: .mathOperator)
    }

    
    static func generateText(value: String, textRange: NSRange?, color: UIColor, scale: CGFloat) -> EquationView {
        let label = UILabel(frame: .zero)
        let atributedString = NSMutableAttributedString(string: value)
        if let range = textRange  {
            atributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: Equation.selectedColor, range: range)
        }
        label.attributedText = atributedString
        label.backgroundColor = color
        label.font = label.font.withSize(17*scale)
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label, type: .text)
    }
    
    static func generateEmpty(backgroundColor: UIColor = Equation.defaultColor, squareColor: UIColor = UIColor.black, scale: CGFloat) -> EquationView {
        let squareViewHeight = 20*scale
        let squareRectOffset = 2*scale
        let squerRectHeight = squareViewHeight - 2*squareRectOffset
        
        let square = UIView(frame: .zero)
        square.frame.size = CGSize(width: squareViewHeight, height: squareViewHeight)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: squareRectOffset, y: squareRectOffset, width: squerRectHeight, height: squerRectHeight)).cgPath
        layer.lineWidth = layer.lineWidth*scale
        layer.fillColor = backgroundColor.cgColor
        layer.strokeColor = squareColor.cgColor
        square.layer.addSublayer(layer)

        return EquationView(view: square, type: .other)
    }
    
    static func generateFraction(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        guard inputViews.count == 2 else { return .Nil }
        var fractionViews: [EquationView] = inputViews
        let enumerator = inputViews[0]
        let denominator = inputViews[1]
        
        guard let enumeratorView = enumerator.view, let denominatorView = denominator.view else { return .Nil}

        var fractionLine: EquationView {
            let line = UIView(frame: .zero)
            let width = (max(enumeratorView.bounds.width, denominatorView.bounds.width) + 5) //* CGFloat(scale)
            let height: CGFloat = 1.5 * scale
            line.frame.size = CGSize(width: width, height: height  )
            line.backgroundColor = color
            return EquationView(view: line, type: .other)
        }
        fractionViews.insert(fractionLine, at: 1)
        guard let fractionLineView = fractionLine.view else { return .Nil}
        
        let width: CGFloat = fractionLineView.frame.width + 4
        
        let fraction: EquationView = EquationView(view: UIView(frame: .zero), type: .fraction)
        var fractionView: UIView = UIView(frame: .zero)
        
        var y: CGFloat = 0.0

        for index in 0...fractionViews.count-1 {
            let item = fractionViews[index]
            guard let view = item.view else { return .Nil }
            
            if index == 1 {
                fraction.horizontalOffset = y
            }
            view.center.x = width / 2
            view.frame.origin.y = y
            fractionView.addSubview(view)
            y += view.bounds.height
        }
        fractionView.frame = CGRect(x: 0, y: 0, width: width , height: y)
        if brackets { addBrackets(to: &fractionView, withScale: scale, andColor: color) }
        fractionView.backgroundColor = selectedColor
        fractionView.layer.cornerRadius = 5
        fraction.view = fractionView
        return fraction
    }
    
    static func generateRoot(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        guard inputViews.count == 2 else { return .Nil}
        let radicand = inputViews[1]
        let rootIndex = inputViews[0]
        guard let radicandView = radicand.view, let rootIndexView = rootIndex.view else { return .Nil}
        var rootView = RootView(rootIndex: rootIndexView, theOtherView: radicandView, radicandHorizontalOffset: radicand.horizontalOffset)
        rootView.scale = scale
        rootView.strokeColor = color

        //if brackets { rootView = addBrackets(to: rootView, withScale: scale, andColor: color)}
        if brackets {
            let viewWithBrackets = BracketsView(viewInBrackets: rootView)
            viewWithBrackets.strokeColor = color
            viewWithBrackets.scale = scale
            viewWithBrackets.backgroundColor = selectedColor
            return EquationView(view: viewWithBrackets, horizontalOffset: rootView.offset, type: .root)
        } else {
            rootView.backgroundColor = selectedColor
            return EquationView(view: rootView, horizontalOffset: rootView.offset, type: .root)
        }        
    }
    
    static func generateExponentAndIndex (_ inputViews: [EquationView], type: ExpressionType, selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        // NOTE: Always have 3 views if there should not be an indrx have it to .Nil
        guard inputViews.count > 1 else { return .Nil }
        var viewIndex = 0
        let base = inputViews[0]
        
        guard let baseView = base.view else { return .Nil }
        
        var frameHeight = baseView.frame.height
        var frameWidth = baseView.frame.width
        var offset = base.horizontalOffset
        
        let newView = UIView(frame: .zero)
        baseView.frame.origin = .zero
        
        if type == .exponent || type == .indexAndExponent {
            viewIndex += 1
            guard let exponenView = inputViews[viewIndex].view else { return .Nil}
            exponenView.frame.origin = CGPoint(x: baseView.frame.width, y: 0)
            frameHeight += exponenView.frame.height - 10*scale
            frameWidth += exponenView.frame.width
            baseView.frame.origin.y += exponenView.frame.height - 10*scale
            offset += exponenView.frame.height - 10*scale
            newView.addSubview(exponenView)
        }
        
        if type == .index || type == .indexAndExponent {
            viewIndex += 1
            guard let indexView = inputViews[viewIndex].view else { return .Nil}
            indexView.frame.origin = CGPoint(x: baseView.frame.width, y: frameHeight - 10*scale)
            frameHeight += indexView.frame.height - 10*scale
            frameWidth = max(frameWidth, baseView.frame.width + indexView.frame.width)
            newView.addSubview(indexView)
        }
        newView.addSubview(baseView)
        newView.frame = CGRect(x: 0, y: 0, width: frameWidth + 2, height: frameHeight)
        newView.backgroundColor = selectedColor
        newView.layer.cornerRadius = 5
        if brackets {
            let viewWithBrackets = BracketsView(viewInBrackets: newView)
            viewWithBrackets.strokeColor = color
            viewWithBrackets.scale = scale
            viewWithBrackets.backgroundColor = selectedColor
            return EquationView(view: viewWithBrackets, horizontalOffset: offset, type: type)
        } else {
            return EquationView(view: newView, horizontalOffset: offset, type: type)
        }
    }
    
    static func generateLogarithm(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1) -> EquationView {
        
        guard inputViews.count == 3 else { return .Nil }
        
        var logView: UILabel {
            var label = UILabel(frame: .zero)
            label.text = "log"
            label.font = label.font.withSize(17*scale)
            label.textColor = color
            label.sizeToFit()
            return label
        }
        return .Nil
    }
}


// MARK: - Equation view tools
extension EquationView {
    
    static private func linearComponentHiightAndOffset(inputViews: [EquationView]) ->  (height: CGFloat, offset: CGFloat) {
        var offsetTop: CGFloat = 0
        var offserBottom: CGFloat = 0
        inputViews.forEach { item in
            guard let view = item.view else { return }
            if item.horizontalOffset > offsetTop {
                offsetTop = item.horizontalOffset
            }
            
            if view.frame.height - item.horizontalOffset > offserBottom {
                offserBottom = view.frame.height - item.horizontalOffset
            }
        }
        return (height: offserBottom + offsetTop, offset: offsetTop)
    }
    static private func addBrackets(to view: inout UIView, withScale scale: CGFloat, andColor color: UIColor) {
        let viewWithBrackets = BracketsView(viewInBrackets: view)
        viewWithBrackets.strokeColor = color
        viewWithBrackets.scale = scale
        view = viewWithBrackets
    }
}
