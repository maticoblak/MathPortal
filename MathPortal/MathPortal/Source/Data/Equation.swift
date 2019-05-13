//
//  Equation.swift
//  MathPortal
//
//  Created by Petra Čačkov on 26/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Equation {
    
    static let selectedColor = UIColor.lightGray
    static let defaultColor = UIColor.clear

    
    var expression: Component = Component()
    
    func computeResult() -> Double? {
        return expression.computeResult()
    }
    
    lazy private var currentIndicator: Indicator = {
        return Indicator(expression: expression)
    }()
    
    
    func handelMathKeyboardButtonsPressed(button: Button.ButtonType) {
        switch button {
        case .integer(let value):
            currentIndicator.addInteger(value: String(value))
        case .plus:
            currentIndicator.addOperator(.plus)
        case .minus:
            currentIndicator.addOperator(.minus)
        case .brackets:
            currentIndicator.addComponentInBrackets()
            break
        case .back:
            currentIndicator.back()
           break
        case .delete:
            currentIndicator.delete()
            break
        case .forward:
            currentIndicator.forward()
        case .levelIn:
            currentIndicator.levelIn()
            break
        case .levelOut:
            currentIndicator.levelOut()
            break
        case .done:
            break
        case .indicator:
            break
        case .fraction:
            currentIndicator.addFraction()
            break 
        }
    }
}

// MARK: - Expressions

extension Equation {
    
    struct View {
        var view: UIView?
        var horizontalOffset: CGFloat
        
        static let Nil = View(view: nil)
        
        init(view: UIView?, horizontalOffset: CGFloat) { self.view = view; self.horizontalOffset = horizontalOffset }
        init(view: UIView?) {
            self.view = view;
            if let view = view {
                self.horizontalOffset = view.bounds.height*0.5
            } else {
                self.horizontalOffset = 0.0
            }
        }
    }
    
    class Expression {
        weak var parent: Component?
        var color: UIColor = defaultColor
        func computeResult() -> Double? { return nil }
        
        func generateView() -> View { return .Nil }
    }
    
    class Operator: Expression {
        enum OperatorType {
            case plus
            case minus
        }
        
        var type: OperatorType
        
        init(_ type: OperatorType) {
            self.type = type
        }
        
        override func generateView() -> View {
            let label = UILabel(frame: .zero)
            label.text = {
                switch self.type {
                case .plus: return "+"
                case .minus: return "-"
                }
            }()
            label.backgroundColor = color
            label.sizeToFit()
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5
            return View(view: label)
        }
    }
    
    class Text: Expression {
        var value: String
        var textRange: NSRange?
        init(_ value: String) {
            self.value = value
        }
        
        override func computeResult() -> Double? {
            return Double(value)
        }
        
        override func generateView() -> View {
            let label = UILabel(frame: .zero)
            let atributedString = NSMutableAttributedString(string: value)
            if let range = textRange  {
                atributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: selectedColor, range: range)
                
            }
            label.attributedText = atributedString
            label.backgroundColor = color
            label.sizeToFit()
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5
            return View(view: label)
        }
    }
    
    class Component: Expression {
        var showBrackets: Bool = false
        var fraction: Bool = false
        var items: [Expression] = [Expression]()
        
        convenience init(items: [Expression]) {
            self.init()
            self.items = items
        }
        
        override func computeResult() -> Double? {
            // TODO: fix this, use priorities and stuff
            var value: Double = 0.0
            var isFirst: Bool = true
            var currentOperator: Operator?
            for item in items {
                if isFirst {
                    guard let result = item.computeResult() else { return nil }
                    value = result
                    isFirst = false
                } else if let result = item.computeResult() {
                    if let operant = currentOperator {
                        switch operant.type {
                        case .plus: value += result
                        case .minus: value -= result
                        }
                    } else {
                        return nil
                    }
                } else if let operant = item as? Operator {
                    currentOperator = operant
                } else {
                    return nil
                }
            }
            return value
        }
        
        override func generateView() -> View {
            if fraction {
                return verticalyLayoutViews(items.map { $0.generateView() }, color: color)
            } else {
                return linearlyLayoutViews(items.map { $0.generateView() }, color: color, brackets: showBrackets)
            }
        }
    }
    
    private static func linearlyLayoutViews(_ inputViews: [View], color: UIColor, brackets: Bool) -> View {
        var views: [UIView] = inputViews.compactMap { $0.view }
        if brackets {
            views = addBracketsToView(views: views)
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
        newView.backgroundColor = color
        newView.layer.cornerRadius = 5
        return View(view: newView)
    }
    static private func addBracketsToView(views: [UIView]) -> [UIView] {
        var leftBracket: UILabel  {
            let label = UILabel(frame: .zero)
            label.text = "("
            label.sizeToFit()
            return label
        }
        var rightBracket: UILabel  {
            let label = UILabel(frame: .zero)
            label.text = ")"
            label.sizeToFit()
            return label
        }
        var newViews = views
        newViews.append(rightBracket)
        newViews.insert(leftBracket, at: 0)
        return newViews
    }
    
    private static func verticalyLayoutViews(_ inputViews: [View], color: UIColor) -> View {
        //var views: [UIView] = inputViews.compactMap { $0 }
        //guard views.count == 2 else { return nil }
        var emptyfraction: UIView {
            let square = UIView(frame: .zero)
            square.frame.size = CGSize(width: 20, height: 20)
            square.layer.borderWidth = 1
            return square
        }
        var numerator = inputViews[0].view ?? emptyfraction
        var denominator = inputViews[1].view ?? emptyfraction
        
        var fractionLine: UIView {
            let line = UIView(frame: .zero)
            line.frame.size = CGSize(width: max(numerator.bounds.width, denominator.bounds.width) + 3, height: 1.5  )
            line.backgroundColor = UIColor.black
            return line
        }
        let viewsWithLine = [numerator, fractionLine, denominator]
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
        fractionView.backgroundColor = color
        fractionView.layer.cornerRadius = 5
        return View(view: fractionView)
        
    }
}
