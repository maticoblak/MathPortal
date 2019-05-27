//
//  Equation.swift
//  MathPortal
//
//  Created by Petra Čačkov on 26/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Equation {
    // MARK: - Equation
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
            currentIndicator.addComponent(brackets: true)
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
            currentIndicator.addComponent(Fraction(), brackets: false)
            break 
        }
    }
}

// MARK: - Expressions

extension Equation {
    // MARK: - Expression
    class Expression {
        weak var parent: Component?
        var color: UIColor = defaultColor
        var scale: Double = 1.0
        func computeResult() -> Double? { return nil }
        
        func generateView() -> EquationView { return .Nil }
    }
    // MARK: - Operator
    class Operator: Expression {
        enum OperatorType {
            case plus
            case minus
        }
        
        var type: OperatorType
        
        init(_ type: OperatorType) {
            self.type = type
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateOperator(type, colour: color, scale: scale)
        }
    }
    // MARK: - Text
    class Text: Expression {
        var value: String
        var textRange: NSRange?
        init(_ value: String) {
            self.value = value
        }
        
        override func computeResult() -> Double? {
            return Double(value)
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateText(value: value, textRange: textRange, color: color, scale: scale)
        }
    }
    // MARK: - Fraction
    class Fraction: Component {
        // TODO: Maybe it is better to have empty in the component as all the other Expressions - reduces the if statements in the forward, back, delete,... since now we have to check if the component is empty and if it is, is it also a fraction or a normal component. If Empty expression would be in component that case would never happen
        override var scale: Double  {
            didSet {
                refresh()
            }
        }
        override func refresh() {
            if enumerator is Empty {
                enumerator.scale = self.scale
            }
            if denomenator is Empty {
                denomenator.scale = self.scale
            }
        }
        var enumerator: Expression {
            get { return items[0] }
            set {
                // don't need?
                newValue.parent = self
                if items.isEmpty {
                    //new value has to be empty if we are creating new fraction
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale
                    newValue.parent = newComponent
                    items[0] = newComponent
                // Probably will need in the future or just a safety case
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        var denomenator: Expression {
            get { return items[1] }
            set {
                newValue.parent = self
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale
                    newValue.parent = newComponent
                    items[1] = newComponent
                } else {
                    let newComponent = Component(items: [items[1], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }
            }
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateFraction(items.map { $0.generateView() }, selectedColor: color, scale: scale)
        }
        func addValues(offset: Int?, expression: Expression?) {
            guard let offset = offset else { return }
            guard let expression = expression else { return }
            if offset == 0  {
                self.enumerator = expression
            } else if offset == 1 {
                self.denomenator = expression
            }
        }
        
        func deleteComponent(offset: Int?) {
            guard let offset = offset else { return }
            guard offset == 0 || offset == 1 else { return }
            guard self.items[offset] is Empty == false else { return }
            let empty = Empty()
            empty.parent = self
            self.items[offset] = empty
        }
        init(enumerator: Expression?, denomenator: Expression?) {
            super.init()
            self.enumerator = enumerator ?? Empty()
            self.denomenator = denomenator ?? Empty()
        }
        override convenience init() {
            self.init(enumerator: Empty(), denomenator: Empty())
        }
    }
    // MARK: - Empty
    class Empty: Expression {
        
        override func generateView() -> EquationView {
            return EquationView.generateEmpty(backgroundColor: color, scale: scale)
        }
    }
    // MARK: - Component
    class Component: Expression {
        var showBrackets: Bool = false
        var fraction: Bool = false
        var items: [Expression] = [Expression]()
        override var scale: Double {
            didSet {
                refresh()
            }
        }
        
        convenience init(items: [Expression]) {
            self.init()
            items.forEach { $0.parent = self; $0.scale = self.scale }
            self.items = items
        }
        func refresh() {
            if items.count == 1 {
                items[0].scale = self.scale
            }
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
        
        override func generateView() -> EquationView {
            return EquationView.linearlyLayoutViews(items.map { $0.generateView() }, selectedColor: color, brackets: showBrackets, scale: scale)
        }
    }
}
