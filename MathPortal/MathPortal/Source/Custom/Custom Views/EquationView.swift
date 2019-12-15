//
//  EquationView.swift
//  MathPortal
//
//  Created by Petra Čačkov on 21/05/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class EquationView {
    
    private(set) var view: UIView?
    private(set) var verticalOffset: CGFloat
    private(set) var type: Equation.ExpressionType
    
    static let Nil = EquationView(view: nil, type: nil )
    
    init(view: UIView?, verticalOffset: CGFloat, type: Equation.ExpressionType) {
        self.view = view
        self.verticalOffset = verticalOffset
        self.type = type
    }
    convenience init(view: UIView?, type: Equation.ExpressionType?) {
        let offset: CGFloat = {
            guard let view = view else { return 0 }
            return view.bounds.height*0.5
        }()
        self.init(view: view, verticalOffset: offset, type: type ?? .other)
    }
    
}

// MARK: - Layout

extension EquationView {
    
    static func linearlyLayoutViews(_ inputViews: [EquationView], type: Equation.ExpressionType, selectedColor: UIColor = Equation.defaultColor, brackets: Bool, color: UIColor = UIColor.black, scale: CGFloat) -> EquationView {
        let equationViews: [EquationView] = inputViews
        
        let views: [UIView] = inputViews.compactMap { $0.view }
        guard views.count > 0 else { return .Nil }
        
        let heightOffset = linearComponentHeightAndOffset(inputViews: equationViews)
        
        var newView = UIView(frame: .zero)
        var x: CGFloat = 0.0
        
        equationViews.forEach { item in
            guard let view = item.view else { return }
            view.frame.origin.x = x
            view.frame.origin.y = heightOffset.offset - item.verticalOffset
            newView.addSubview(view)
            
            x += view.bounds.width
        }
        newView.frame = CGRect(x: 0.0, y: 0.0, width: x, height: heightOffset.height)
        var currentType: Equation.ExpressionType = type
        if brackets {
            currentType = .brackets
            newView = addBrackets(to: newView, withScale: scale, andColor: color)
        }
        
        newView.backgroundColor = selectedColor
        newView.layer.cornerRadius = 5
        return EquationView(view: newView, verticalOffset: heightOffset.offset, type: currentType)
    }
    
}


// MARK: - Expression views

extension EquationView {
    
    static func generateOperator(_ operatorType: Equation.Operator.OperatorType, backgroundColor: UIColor = Equation.defaultColor, scale: CGFloat = 1, color: UIColor = UIColor.black) -> EquationView {
        let label = UILabel(frame: .zero)
        label.text = operatorType.string
        label.backgroundColor = backgroundColor
        label.font = label.font.withSize(17*CGFloat(scale))
        label.textColor = color
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label, type: .mathOperator)
    }

    
    static func generateText(value: String, textRange: NSRange? = nil, backgroundColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1) -> EquationView {
        let label = UILabel(frame: .zero)
        let attributed = NSMutableAttributedString(string: value)
        if let range = textRange  {
            attributed.addAttribute(NSAttributedString.Key.backgroundColor, value: Equation.selectedColor, range: range)
        }
        label.attributedText = attributed
        label.backgroundColor = backgroundColor
        label.textColor = color
        label.font = label.font.withSize(17*scale)
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label, type: .text)
    }
    
    static func generateEmpty(backgroundColor: UIColor = Equation.defaultColor, squareColor: UIColor = UIColor.black, scale: CGFloat) -> EquationView {
        let squareViewHeight = 20*scale
        let squareRectOffset = 2*scale
        let squareRectHeight = squareViewHeight - 2*squareRectOffset
        
        let square = UIView(frame: .zero)
        square.frame.size = CGSize(width: squareViewHeight, height: squareViewHeight)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: squareRectOffset, y: squareRectOffset, width: squareRectHeight, height: squareRectHeight)).cgPath
        layer.lineWidth = layer.lineWidth*scale
        layer.fillColor = backgroundColor.cgColor
        layer.strokeColor = squareColor.cgColor
        square.layer.addSublayer(layer)

        return EquationView(view: square, type: .empty)
    }
    
    static func generateFraction(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        guard inputViews.count == 2 else { return .Nil } // Must have 2 views
        
        guard let enumeratorView = inputViews[0].view, let denominatorView = inputViews[1].view else { return .Nil }
        
        let itemsWidth = max(enumeratorView.bounds.width, denominatorView.bounds.width)
        let lineWidth = itemsWidth + 5 // Add 5 pixels to line
        let wholeWidth = lineWidth + 4 // Add 2 pixels offset on each side to self
        
        let fractionLineView: UIView = {
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: lineWidth, height: 1.5 * scale))
            line.backgroundColor = color
            return line
        }()
        
        let allViews = [enumeratorView, fractionLineView, denominatorView]
        
        // Layout positions
        var y: CGFloat = 0.0
        allViews.forEach { view in
            view.center.x = wholeWidth / 2
            view.frame.origin.y = y
            y += view.bounds.height
        }
        
        let view: UIView = {
            let fractionView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: wholeWidth, height: y))
            allViews.forEach { fractionView.addSubview($0) }
            if brackets {
                return addBrackets(to: fractionView, withScale: scale, andColor: color)
            } else {
                return fractionView
            }
        }()
        
        view.backgroundColor = selectedColor
        view.layer.cornerRadius = 5
        
        return EquationView(view: view, verticalOffset: fractionLineView.center.y, type: .fraction)
    }
    
    static func generateRoot(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        guard inputViews.count == 2 else { return .Nil}
        let radicand = inputViews[1]
        let rootIndex = inputViews[0]
        guard let radicandView = radicand.view, let rootIndexView = rootIndex.view else { return .Nil}
        
        let rootView = RootView(rootIndex: rootIndexView, theOtherView: radicandView, radicandHorizontalOffset: radicand.verticalOffset, scale: scale, strokeColor: color)
        
        if brackets {
            return EquationView(view: addBrackets(to: rootView, withScale: scale, andColor: color), verticalOffset: rootView.offset, type: .root)
        } else {
            rootView.backgroundColor = selectedColor
            return EquationView(view: rootView, verticalOffset: rootView.offset, type: .root)
        }        
    }
    
    static func generateIntegral(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        guard  inputViews.count == 1 else { return .Nil }
        guard let baseView = inputViews.first?.view else { return .Nil}
        
        let integralView = IntegralView(base: baseView)
        
        // TODO: add offset
        if brackets {
            return EquationView(view: addBrackets(to: integralView, withScale: scale, andColor: color), verticalOffset: integralView.bounds.height/2, type: .integral)
        } else {
            integralView.backgroundColor = selectedColor
            return EquationView(view: integralView, verticalOffset: 0, type: .integral)
        }
    }
    
    static func generateExponentAndIndex (_ inputViews: [EquationView], type: Equation.ExpressionType, selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Bool = false) -> EquationView {
        
        guard inputViews.count > 1 else { return .Nil }
        var viewIndex = 0
        let base = inputViews[0]
        
        guard let baseView = base.view else { return .Nil }
        
        var frameHeight = baseView.frame.height
        var frameWidth = baseView.frame.width
        var offset = base.verticalOffset
        
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
            return EquationView(view: viewWithBrackets, verticalOffset: offset, type: type)
        } else {
            return EquationView(view: newView, verticalOffset: offset, type: type)
        }
    }
    
    static func generateFunction(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: CGFloat = 1, type: Equation.ExpressionType, brackets: Bool = false) -> EquationView {
        guard inputViews.count > 0 else { return .Nil }
        
        let text: String? = type.symbol
        
        var textView: EquationView = {
            let label = UILabel(frame: .zero)
            label.text = text
            label.font = label.font.withSize(17*scale)
            label.textColor = color
            label.sizeToFit()
            return EquationView(view: label, type: .other)
        }()
        
        let functionView: EquationView = {
            var view: EquationView
            if inputViews.count == 2 {
                view = generateExponentAndIndex([textView, inputViews[1]], type: .index, scale: scale)
            } else {
                view = textView
            }
            return linearlyLayoutViews([view, inputViews[0]], type: type, brackets: brackets, scale: scale)
        }()
        
        functionView.view?.backgroundColor = selectedColor
        return functionView
    }
}


// MARK: - Equation view tools
extension EquationView {
    
    static private func linearComponentHeightAndOffset(inputViews: [EquationView]) ->  (height: CGFloat, offset: CGFloat) {
        var offsetTop: CGFloat = 0
        var offsetBottom: CGFloat = 0
        inputViews.forEach { item in
            guard let view = item.view else { return }
            if item.verticalOffset > offsetTop {
                offsetTop = item.verticalOffset
            }
            
            if view.frame.height - item.verticalOffset > offsetBottom {
                offsetBottom = view.frame.height - item.verticalOffset
            }
        }
        return (height: offsetBottom + offsetTop, offset: offsetTop)
    }
    static private func addBrackets(to view: UIView, withScale scale: CGFloat, andColor color: UIColor) -> BracketsView {
        let viewWithBrackets = BracketsView(viewInBrackets: view)
        viewWithBrackets.strokeColor = color
        viewWithBrackets.scale = scale
        return viewWithBrackets
    }
}

// MARK: extension RootView
private extension RootView {
    
    convenience init(rootIndex: UIView, theOtherView: UIView, radicandHorizontalOffset: CGFloat, scale: CGFloat, strokeColor: UIColor) {
        self.init(rootIndex: rootIndex, theOtherView: theOtherView, radicandHorizontalOffset: radicandHorizontalOffset)
        self.scale = scale
        self.strokeColor = strokeColor
    }
    
}
