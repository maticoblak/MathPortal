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
    private(set) var isSelected: Bool
    
    static let Nil = EquationView(view: nil, type: nil, isSelected: false )
    static private let selectedColor = Color.lightGrey.withAlphaComponent(0.5)
    static private let defaultColor = UIColor.clear
    
    init(view: UIView?, verticalOffset: CGFloat, type: Equation.ExpressionType, isSelected: Bool) {
        self.view = view
        self.verticalOffset = verticalOffset
        self.type = type
        self.isSelected = isSelected
    }
    convenience init(view: UIView?, type: Equation.ExpressionType?, isSelected: Bool) {
        let offset: CGFloat = {
            guard let view = view else { return 0 }
            return view.bounds.height*0.5
        }()
        self.init(view: view, verticalOffset: offset, type: type ?? .other, isSelected: isSelected)
    }
    
}

// MARK: - Layout

extension EquationView {
    
    // MARK: - Linear layout
    static func linearlyLayoutViews(_ inputViews: [EquationView], type: Equation.ExpressionType, isSelected: Bool = false, brackets: Equation.Component.BracketsType, color: UIColor = UIColor.black, scale: CGFloat) -> EquationView {
        let backgroundColor = isSelected ? selectedColor : defaultColor
        guard inputViews.isEmpty == false else {
            let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 5, height: 20*scale)))
            view.backgroundColor = backgroundColor
            view.layer.cornerRadius = 5
            return EquationView(view: view, type: nil, isSelected: isSelected)
        }
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
        var currentType: Equation.ExpressionType
        
        // TODO: figure out if the type should be changed here
        switch brackets {
        case .absolute:
            currentType = .absoluteValue
        case .normal:
            currentType = .brackets
        case .none:
            currentType = type
        }
        newView = addBrackets(to: newView, withScale: scale, andColor: color
            , backgroundColor: backgroundColor, type: brackets)
        newView.backgroundColor = backgroundColor
        newView.layer.cornerRadius = 5
        return EquationView(view: newView, verticalOffset: heightOffset.offset, type: currentType, isSelected: isSelected)
    }
    
    // MARK - Vertical layout
    static func verticalLayoutViews(_ inputViews: [EquationView], centered: Bool, isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        
        guard let itemsWidth = inputViews.compactMap({ $0.view?.bounds.width }).max() else { return .Nil }
        let backgroundColor = isSelected ? selectedColor : defaultColor
        let wholeWidth = itemsWidth + 4 // Add 2 pixels offset on each side to self

        let allViews: [UIView] = {
            var views: [EquationView?] = []
            inputViews.forEach {
                if $0.type == .indicator, let last = views.last as? EquationView {
                    views.removeLast()
                    views.append(linearlyLayoutViews([last, $0], type: .newLine, brackets: .none, scale: scale))
                } else {
                    views.append($0)
                }
            }
            if views.count >= 2, let first = views.first as? EquationView, first.type == .indicator, let second = views[1]  {
                views.removeFirst()
                views[0] = linearlyLayoutViews([first, second], type: .newLine, brackets: .none, scale: scale)
            }
            
            return views.compactMap { $0?.view }
        }()
        
        let view: UIView = {
            
            let verticalView = UIView()
            // Layout positions
            var y: CGFloat = 0.0
            allViews.forEach { view in
                view.frame.origin.x = centered ? (wholeWidth / 2 - view.bounds.width / 2) : 2
                view.frame.origin.y = y
                y += view.bounds.height
                
                verticalView.addSubview(view)
            }
            
            verticalView.frame = CGRect(x: 0.0, y: 0.0, width: wholeWidth, height: y)
            return addBrackets(to: verticalView, withScale: scale, andColor: color, backgroundColor: backgroundColor, type: brackets)
        }()
        
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 5
        
        return EquationView(view: view, verticalOffset: view.center.y, type: .newLine, isSelected: isSelected)
    }
    
}


// MARK: - Expression views

extension EquationView {
    
    // MARK: Operator view
    static func generateOperator(_ operatorType: Equation.Operator.OperatorType, isSelected: Bool = false, scale: CGFloat = 1, color: UIColor = UIColor.black) -> EquationView {
        let mathOperator = generateText(value: operatorType.string, isSelected: isSelected, color: color, scale: scale)
        mathOperator.type = .mathOperator
        return mathOperator
    }

    // MARK: Text view
    static func generateText(value: String, /*textRange: NSRange? = nil,*/ isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1) -> EquationView {
        let label = UILabel(frame: .zero)
        label.text = value
        label.backgroundColor = isSelected ? selectedColor : defaultColor
        label.textColor = color
        label.font = label.font.withSize(17*scale)
        label.textAlignment = .center
        label.sizeToFit()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        return  EquationView(view: label, type: .text, isSelected: isSelected)
    }
    
    // MARK: Space
    static func generateSpace(in parent: Equation.Component?, scale: CGFloat, isSelected: Bool = false) -> EquationView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10*scale, height:  20*scale))
        view.layer.cornerRadius = 5
        view.backgroundColor = isSelected ? selectedColor : defaultColor
        return EquationView(view: view, type: .space, isSelected: isSelected)
    }
    
    // MARK: Empty view
    static func generateEmpty(isSelected: Bool = false, squareColor: UIColor = UIColor.black, scale: CGFloat) -> EquationView {
        let squareViewHeight = 20*scale
        let squareRectOffset = 2*scale
        let squareRectHeight = squareViewHeight - 2*squareRectOffset
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: squareRectOffset, y: squareRectOffset, width: squareRectHeight, height: squareRectHeight)).cgPath
        layer.lineWidth = layer.lineWidth*scale
        layer.fillColor = isSelected ? selectedColor.cgColor : defaultColor.cgColor
        layer.strokeColor = squareColor.cgColor
        
        let square = UIView(frame: CGRect(x: 0, y: 0, width: squareViewHeight, height: squareViewHeight))
        square.layer.addSublayer(layer)

        return EquationView(view: square, type: .empty, isSelected: isSelected)
    }
    
    // MARK: Fraction view
    static func generateFraction(_ inputViews: [EquationView], isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
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
        let backgroundColor = isSelected ? selectedColor : defaultColor
        let view: UIView = {
            let fractionView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: wholeWidth, height: y))
            allViews.forEach { fractionView.addSubview($0) }
            return addBrackets(to: fractionView, withScale: scale, andColor: color, backgroundColor: backgroundColor, type: brackets)
        }()
        
        view.backgroundColor = backgroundColor
        view.layer.cornerRadius = 5
        
        return EquationView(view: view, verticalOffset: fractionLineView.center.y, type: .fraction, isSelected: isSelected)
    }
    
    // MARK: Root view
    static func generateRoot(_ inputViews: [EquationView], isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        guard inputViews.count == 2 else { return .Nil}
        let radicand = inputViews[1]
        let rootIndex = inputViews[0]
        guard let radicandView = radicand.view, let rootIndexView = rootIndex.view else { return .Nil}
        
        let rootView = RootView(rootIndex: rootIndexView, theOtherView: radicandView, radicandHorizontalOffset: radicand.verticalOffset, scale: scale, strokeColor: color)
        let backgroundColor = isSelected ? selectedColor : defaultColor
        if brackets != .none {
            return EquationView(view: addBrackets(to: rootView, withScale: scale, andColor: color, backgroundColor: backgroundColor, type: .normal), verticalOffset: rootView.offset, type: .root, isSelected: isSelected)
        } else {
            rootView.backgroundColor = backgroundColor
            return EquationView(view: rootView, verticalOffset: rootView.offset, type: .root, isSelected: isSelected)
        }        
    }
    
    // MARK: Integral view
    static func generateIntegral(_ inputViews: [EquationView], isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        guard  inputViews.count == 1 else { return .Nil }
        let base = inputViews[0]
        guard let baseView = inputViews.first?.view else { return .Nil}
        
        let integralView = IntegralView(base: baseView, verticalOffset: base.verticalOffset)
        integralView.backgroundColor = isSelected ? selectedColor : defaultColor
    
        return EquationView(view: addBrackets(to: integralView, withScale: scale, andColor: color, backgroundColor: isSelected ? selectedColor : defaultColor, type: brackets), verticalOffset: integralView.verticalOffset, type: .integral, isSelected: isSelected)
    }
    
    // MARK: Exponent and Index view
    static func generateExponentAndIndex (_ inputViews: [EquationView], type: Equation.ExpressionType, isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        
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
        let backgroundColor = isSelected ? selectedColor : defaultColor
        newView.addSubview(baseView)
        newView.frame = CGRect(x: 0, y: 0, width: frameWidth + 2, height: frameHeight)
        newView.backgroundColor = backgroundColor
        newView.layer.cornerRadius = 5
        return EquationView(view: addBrackets(to: newView, withScale: scale, andColor: color, backgroundColor: backgroundColor, type: brackets), verticalOffset: offset, type: type, isSelected: isSelected)
    }
    
    // MARK: Function view
    static func generateFunction(_ inputViews: [EquationView], isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, type: Equation.ExpressionType, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        guard inputViews.count > 0 else { return .Nil }
        
        let textView: EquationView = {
            let label = UILabel(frame: .zero)
            label.text = type.symbol
            label.font = label.font.withSize(17*scale)
            label.textColor = color
            label.sizeToFit()
            return EquationView(view: label, type: .other, isSelected: false)
        }()
        
        let functionView: EquationView = {
            let view: EquationView
            if inputViews.count == 2 {
                let log = generateExponentAndIndex([textView, inputViews[0]], type: .index, scale: scale)
                view = linearlyLayoutViews([log, inputViews[1]], type: type, brackets: brackets, scale: scale)
            } else {
                view = linearlyLayoutViews([textView, inputViews[0]], type: type, brackets: brackets, scale: scale)
            }
            view.view?.backgroundColor = isSelected ? selectedColor : defaultColor
            return view
        }()
        return functionView
    }
    
    // MARK: Limit view
    static func generateLimit(_ inputViews: [EquationView], isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        guard inputViews.count == 3 else { return .Nil }
        let base = inputViews[2]
        let variable = inputViews[0]
        let limit = inputViews[1]
        let text: UILabel = {
            let label = UILabel()
            label.text = "lim"
            label.font = label.font.withSize(17*scale)
            label.textColor = color
            label.sizeToFit()
            return label
        }()
        
        let bottomView = ArrowView(from: variable, to: limit, scale: scale*0.7)
        
        let limView: EquationView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: max(text.bounds.width, bottomView.bounds.width), height: text.bounds.height + bottomView.bounds
                .height))
            text.frame.origin = CGPoint(x: view.bounds.width/2 - text.bounds.width/2, y: 0)
            bottomView.frame.origin = CGPoint(x: view.bounds.width/2 - bottomView.bounds.width/2, y: text.bounds.height)
            [text, bottomView].forEach { view.addSubview($0)}
            view.backgroundColor = .clear
            return EquationView(view: view, verticalOffset: text.center.y, type: .other, isSelected:  false)
        }()
        return linearlyLayoutViews([limView, base], type: .limit ,isSelected: isSelected, brackets: brackets, scale: scale)
    }
    
    static func generateSeries(_ inputViews: [EquationView], type: Equation.Series.SeriesType, isSelected: Bool = false, color: UIColor = UIColor.black, scale: CGFloat = 1, brackets: Equation.Component.BracketsType = .none) -> EquationView {
        guard inputViews.count == 3 else { return .Nil }
        
        let seriesView: SeriesView = SeriesView(type: type, scale: scale, baseView: inputViews[2], minView: inputViews[0], maxView: inputViews[1], color: color)
        seriesView.backgroundColor = isSelected ? selectedColor : defaultColor
        let offset = inputViews[2].verticalOffset + (inputViews[1].view?.bounds.height ?? 0) + 3*seriesView.indent.vertical
        return EquationView(view: seriesView, verticalOffset: offset, type: type.equationType, isSelected: isSelected)
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
    static private func addBrackets(to view: UIView, withScale scale: CGFloat, andColor strokeColor: UIColor, backgroundColor: UIColor, type: Equation.Component.BracketsType) -> UIView {
        switch type {
        case .none:
            return view
        case  .absolute, .normal:
            let viewWithBrackets: BracketsView = BracketsView(viewInBrackets: view, type: type)
            viewWithBrackets.strokeColor = strokeColor
            viewWithBrackets.scale = scale
            viewWithBrackets.backgroundColor = backgroundColor
            return viewWithBrackets
        }
    }
    
    static func generateIndicator(scale: CGFloat) -> EquationView {
        let indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 20*scale))
        indicatorView.backgroundColor = Color.orange
        indicatorView.layer.cornerRadius = indicatorView.bounds.width/2
        return EquationView(view: indicatorView, type: .indicator, isSelected: false)
    }
}


