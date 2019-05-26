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

    static func linearlyLayoutViews(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, brackets: Bool, color: UIColor = UIColor.black, scale: Double) -> EquationView {
        var equationViews: [EquationView] = inputViews
        if brackets {
            //let height = equationViews.compactMap { $0.view?.frame.height }.max()
            let height = linearComponentHiightAndOffset(inputViews: equationViews)
            //guard let bracketHeight = height else { return .Nil}
            equationViews = addBracketsToView(views: inputViews, color: color, scale: scale, height: height.height, offset: height.offset)
        }
        let views: [UIView] = inputViews.compactMap { $0.view }
        guard views.count > 0 else { return .Nil }
        
        let heightOffset = linearComponentHiightAndOffset(inputViews: equationViews)
        
        let newView = UIView(frame: .zero)
        var x: CGFloat = 0.0
        
        equationViews.forEach { item in
            guard let view = item.view else { return }
            view.frame.origin.x = x
            view.frame.origin.y = heightOffset.offset - item.horizontalOffset
            newView.addSubview(view)
            
            x += view.bounds.width
            
        }
        newView.frame = CGRect(x: 0.0, y: 0.0, width: x, height: heightOffset.height)
        newView.backgroundColor = selectedColor
        newView.layer.cornerRadius = 5
        
        return EquationView(view: newView, horizontalOffset: heightOffset.offset)
    }
}

// MARK: - Expresson views
extension EquationView {
    
    static func generateOperator(_ operatorType: Equation.Operator.OperatorType, colour: UIColor, scale: Double) -> EquationView {
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
        return EquationView(view: label)
    }

    
    static func generateText(value: String, textRange: NSRange?, color: UIColor, scale: Double) -> EquationView {
        let label = UILabel(frame: .zero)
        let atributedString = NSMutableAttributedString(string: value)
        if let range = textRange  {
            atributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: Equation.selectedColor, range: range)
        }
        label.attributedText = atributedString
        label.backgroundColor = color
        label.font = label.font.withSize(17*CGFloat(scale))
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return EquationView(view: label)
    }
    
    static func generateEmpty(backgroundColor: UIColor = Equation.defaultColor, squareColor: UIColor = UIColor.black, scale: Double) -> EquationView {
        let squareViewHeight = 20*scale
        let squareRectOffset = 2*scale
        let squerRectHeight = squareViewHeight - 2*squareRectOffset
        
        let square = UIView(frame: .zero)
        square.frame.size = CGSize(width: squareViewHeight, height: squareViewHeight)
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: squareRectOffset, y: squareRectOffset, width: squerRectHeight, height: squerRectHeight)).cgPath
        layer.lineWidth = layer.lineWidth*CGFloat(scale)
        layer.fillColor = backgroundColor.cgColor
        layer.strokeColor = squareColor.cgColor
        square.layer.addSublayer(layer)

        return EquationView(view: square)
    }
    
    static func generateFraction(_ inputViews: [EquationView], selectedColor: UIColor = Equation.defaultColor, color: UIColor = UIColor.black, scale: Double = 1) -> EquationView {
        guard inputViews.count == 2 else { return .Nil }
        var fractionViews: [EquationView] = inputViews
        let enumerator = inputViews[0]
        let denominator = inputViews[1]
        
        guard let enumeratorView = enumerator.view, let denominatorView = denominator.view else { return .Nil}

        var fractionLine: EquationView {
            let line = UIView(frame: .zero)
            let width = (max(enumeratorView.bounds.width, denominatorView.bounds.width) + 5) //* CGFloat(scale)
            let height: CGFloat = 1.5 * CGFloat(scale)
            line.frame.size = CGSize(width: width, height: height  )
            line.backgroundColor = color
            return EquationView(view: line)
        }
        fractionViews.insert(fractionLine, at: 1)
        guard let fractionLineView = fractionLine.view else { return .Nil}
        
        let width: CGFloat = fractionLineView.frame.width + 4
        
        let fraction: EquationView = EquationView(view: UIView(frame: .zero))
        let fractionView: UIView = UIView(frame: .zero)
        
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
        fractionView.backgroundColor = selectedColor
        fractionView.layer.cornerRadius = 5
        fraction.view = fractionView
        return fraction
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
    
    
    static private func addBracketsToView(views: [EquationView], color: UIColor = Equation.defaultColor, scale: Double, height: CGFloat, offset: CGFloat) -> [EquationView] {
        var leftBracket: UILabel  {
            let label = UILabel(frame: .zero)
            label.text = "("
            label.font = label.font.withSize(17*CGFloat(scale))
            while label.font.lineHeight < height {
                label.font = label.font.withSize( label.font.pointSize + 1)
                label.sizeToFit()
            }
            label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
            label.font = UIFont(name: "Baskerville", size: label.font.pointSize)
            label.textColor = color
            label.sizeToFit()
            return label
        }
        var rightBracket: UILabel  {
            let label = UILabel(frame: .zero)
            label.text = ")"
            label.font = label.font.withSize(17*CGFloat(scale))
            while label.font.lineHeight < height {
                label.font = label.font.withSize( label.font.pointSize + 1)
                label.sizeToFit()
            }
            label.font = UIFont(name: "Baskerville", size: label.font.pointSize)
            label.textColor = color
            label.sizeToFit()
            return label
        }
        var newViews = views
        newViews.append(EquationView(view: rightBracket, horizontalOffset: offset))
        newViews.insert(EquationView(view: leftBracket, horizontalOffset: offset), at: 0)
        return newViews
    }
    
}
