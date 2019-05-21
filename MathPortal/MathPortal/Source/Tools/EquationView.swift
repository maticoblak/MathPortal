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
    
    static let Nil = EquationView(view: nil)
    
    init(view: UIView?, horizontalOffset: CGFloat) { self.view = view; self.horizontalOffset = horizontalOffset }
    init(view: UIView?) {
        self.view = view;
        if let view = view {
            self.horizontalOffset = view.bounds.height*0.5
        } else {
            self.horizontalOffset = 0.0
        }
    }

    static func linearlyLayoutViews(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, brackets: Bool, color: UIColor = UIColor.black) -> EquationView {
        var views: [UIView] = inputViews.compactMap { $0.view }
        if brackets {
            views = addBracketsToView(views: views, color: color)
        }
        guard views.count > 0 else { return .Nil }
        
        var frame: CGRect = views[0].bounds
        for index in 1..<views.count {
            frame = frame.union(views[index].bounds)
        }
        
        let newView = UIView(frame: .zero)
        var x: CGFloat = 0.0
        
        views.forEach { item in
            item.frame.origin.x = x
            item.frame.origin.y = frame.height/2.0 - item.bounds.height/2.0
            
            newView.addSubview(item)
            
            x += item.bounds.width
        }
        
        newView.frame = CGRect(x: 0.0, y: 0.0, width: x, height: frame.height)
        newView.backgroundColor = selectedColor
        newView.layer.cornerRadius = 5
        return EquationView(view: newView)
    }
    
    
    
    static func addBracketsToView(views: [UIView], color: UIColor = Equation.defaultColor) -> [UIView] {
        var leftBracket: UILabel  {
            let label = UILabel(frame: .zero)
            label.text = "("
            label.sizeToFit()
            label.textColor = color
            return label
        }
        var rightBracket: UILabel  {
            let label = UILabel(frame: .zero)
            label.text = ")"
            label.sizeToFit()
            label.textColor = color
            return label
        }
        var newViews = views
        newViews.append(rightBracket)
        newViews.insert(leftBracket, at: 0)
        return newViews
    }
}

// MARK: - Expresson views
extension EquationView {
    
    static func generateOperator(_ operatorType: Equation.Operator.OperatorType, colour: UIColor) -> EquationView {
        let label = UILabel(frame: .zero)
        label.text = {
            switch operatorType {
            case .plus: return "+"
            case .minus: return "-"
            }
        }()
        label.backgroundColor = colour
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label)
    }

    
    static func generateText(value: String, textRange: NSRange?, color: UIColor) -> EquationView {
        let label = UILabel(frame: .zero)
        let atributedString = NSMutableAttributedString(string: value)
        if let range = textRange  {
            atributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: Equation.selectedColor, range: range)
        }
        label.attributedText = atributedString
        label.backgroundColor = color
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label)
    }
    
    static func generateEmpty(backgroundColor: UIColor = Equation.defaultColor, squareColor: UIColor = UIColor.black) -> EquationView {
        let squareViewHeight = 20
        let squareRectOffset = 2
        let SquerRectHeight = squareViewHeight - 2*squareRectOffset
        
        let square = UIView(frame: .zero)
        square.frame.size = CGSize(width: squareViewHeight, height: squareViewHeight)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: squareRectOffset, y: squareRectOffset, width: SquerRectHeight, height: SquerRectHeight)).cgPath
        
        layer.fillColor = backgroundColor.cgColor
        layer.strokeColor = squareColor.cgColor
        square.layer.addSublayer(layer)

        return EquationView(view: square)
    }
    
    static func generateFraction(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black) -> EquationView {
        
        guard inputViews.count == 2 else { return .Nil }
        guard let enumerator = inputViews[0].view, let denominator = inputViews[1].view else { return .Nil}

        var fractionLine: UIView {
            let line = UIView(frame: .zero)
            line.frame.size = CGSize(width: max(enumerator.bounds.width, denominator.bounds.width) + 3, height: 1.5  )
            line.backgroundColor = color
            return line
        }
        let viewsWithLine = [enumerator, fractionLine, denominator]
        let width: CGFloat = fractionLine.frame.width + 4
        
        let fractionView: UIView = UIView(frame: .zero)
        
        var y: CGFloat = 0.0
        viewsWithLine.forEach { item in
            item.center.x = width / 2
            item.frame.origin.y = y
            
            fractionView.addSubview(item)
            
            y += item.bounds.height
        }
        
        fractionView.frame = CGRect(x: 0, y: 0, width: width , height: y)
        fractionView.backgroundColor = selectedColor
        fractionView.layer.cornerRadius = 5
        return EquationView(view: fractionView)
    }
}
