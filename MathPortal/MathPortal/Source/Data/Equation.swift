//
//  Equation.swift
//  MathPortal
//
//  Created by Petra Čačkov on 26/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Equation {
    
    private class Indicator {
        var expression: Expression
        var offset: Int = 0
        init(expression: Expression) {
            self.expression = expression
        }
        
        func levelIn() {
            guard let component = expression as? Component else { return }
            guard component.items.count > offset, offset >= 0 else { return }  // if you are at the end of the equation the offset is greater then the index of last element since the last element hasn't ben added yet and similar if you are at the beginning the offset is less than 0
            guard component.items[offset] as? Operator == nil else { return }
            self.expression = component.items[offset]
            self.expression.color = UIColor.clear
            offset = 0
            if let text = self.expression as? Text {
                text.textRange = NSRange(location: 0, length: 1)
            } else if let component = self.expression as? Component {
                if component.items.count > 0 {
                    component.items[0].color = UIColor.red
                }
            }
        }
        func levelOut() {
            guard let parent = expression.parent else { return }
            guard let index = parent.items.firstIndex(where: {$0 === self.expression}) else { return }
            if let text = expression as? Text {
                text.textRange = nil
            }
            self.offset = index
            parent.items[index].color = UIColor.red
            self.expression = parent
        }
        func forward() {
            if let component = expression as? Component {
                if offset < component.items.count {
                    offset += 1
                    if offset - 1 >= 0 {
                        component.items[offset-1].color = UIColor.clear
                    }
                    if offset < component.items.count {
                        component.items[offset].color = UIColor.red
                    }
                } else if let parent = expression.parent {
                    if let currentIndex = parent.items.firstIndex(where: {$0 === expression}) {
                        if currentIndex < parent.items.count {
                            self.offset = currentIndex
                            parent.items[offset].color = UIColor.red
                            self.expression = parent
                        }
                    }
                }
            } else if let text = expression as? Text {
                if offset < text.value.count - 1 {
                    offset += 1
                    text.textRange = NSRange(location: offset, length: 1)
                    text.parent?.color = UIColor.clear
                } else {
                    text.textRange = nil
                    if let parent = expression.parent {
                        if let currentIndex = parent.items.firstIndex(where: { $0 === expression }) {
                            self.expression = parent
                            self.offset = currentIndex + 1
                            if currentIndex < parent.items.count-1 {
                                if let component =  expression as? Component {
                                    component.items[offset].color = UIColor.red
                                } else {
                                    expression.color = UIColor.red
                                }
                            }
                        }
                    }
                }
            }
        }
        func back() {
            if let component = expression as? Component {
                if offset  >= 0 {
                    offset -= 1
                    if offset >= 0 {
                        component.items[offset].color = UIColor.red
                    }
                    if offset + 1 < component.items.count {
                        component.items[offset + 1].color = UIColor.clear
                    }
                } else if let parent = expression.parent {
                    if let currentIndex = parent.items.firstIndex(where: {$0 === expression}) {
                        if currentIndex < parent.items.count {
                            self.offset = currentIndex
                            parent.items[offset].color = UIColor.red
                            self.expression = parent
                            
                        }
                    }
                }
                
                if component.items.isEmpty {
                    offset = 0
                }

            } else if let text = expression as? Text {
                if offset > 0 {
                    offset -= 1
                    text.textRange = NSRange(location: offset, length: 1)
                } else {
                    text.textRange = nil
                    if let parent = expression.parent {
                        if let currentIndex = parent.items.firstIndex(where: { $0 === expression }) {
                            self.expression = parent
                            if currentIndex > 0 {
                                self.offset = currentIndex - 1
                            } else {
                                self.offset = 0
                            }
                            if let component = expression as? Component {
                                component.items[offset].color = UIColor.red
                            } else {
                                expression.color = UIColor.red
                            }
                        }
                    }
                }
            }
        }
        /*
         - if the expression is a Component and if the indicator is at the end of equation add Character to the existing Text component or append new Text expression
         - if the expression is Text add a character to the value
         */
        func addInteger(value: String?) {
            guard let value = value else { return }
            if let component = expression as? Component {
                if offset == component.items.count {
                    if let text = component.items.last as? Text {
                        text.value += value
                    } else {
                        component.items.append({
                            let newExpression = Text(value)
                            newExpression.parent = component
                            return newExpression
                        }())
                        offset += 1
                    }
                } else if offset < 0 {
                    if let text = component.items[0] as? Text {
                        text.value.insert(Character(value), at: text.value.startIndex)
                    } else {
                        component.items.insert({
                            let newExpression = Text(value)
                            newExpression.parent = component
                            return newExpression
                        }(), at: 0)
                    }
                }
            } else if let text = expression as? Text {
                text.value.insert(Character(value), at: text.value.index(text.value.startIndex, offsetBy: offset))
                forward()
            }
        }
        /*
         - if the expression is a Component
            and the indicator is at the end of equation
                change the operator type or append new operator
            if the indicator is at the beginning of equation eather add new operator or change existion one
            If the indicator is in the middle of equation change the operator type
         - if the expression is a Text
            create two Text expressions, remove the previous one and append them to the component with the operator inbetween*/
        func addOperator(_ operatorType: Operator.OperatorType ) {
            if let component = expression as? Component {
                if offset == component.items.count {
                    if let last = component.items.last as? Operator {
                        last.type = operatorType
                    } else {
                        component.items.append({
                            let newExpression = Operator(operatorType)
                            newExpression.parent = component
                            return newExpression
                            }())
                        component.items[offset].color = UIColor.clear
                        offset += 1
                    }
                } else if offset < 0 {
                    if let first = component.items[0] as? Operator {
                        first.type = operatorType
                    } else {
                        component.items.insert({
                            let newExpression = Operator(operatorType)
                            newExpression.parent = component
                            return newExpression
                        }(), at: 0)
                    }
                } else if let operatorAtIndex = component.items[offset] as? Operator {
                    operatorAtIndex.type = operatorType
                }
            } else if let text = expression as? Text {
                guard offset > 0 else { return }
                let firstValue = Text(String(text.value.prefix(offset)))
                firstValue.parent = text.parent
                let secondValue = Text(String(text.value.suffix(text.value.count - offset)))
                secondValue.parent = text.parent
                let newOperator = Operator(operatorType)
                newOperator.parent = text.parent
                
                if let parent = text.parent {
                    if let parentIndex = parent.items.firstIndex(where: {$0 === expression}) {
                        parent.items.remove(at: parentIndex)
                        parent.items.insert(secondValue, at: parentIndex)
                        parent.items.insert(newOperator, at: parentIndex)
                        parent.items.insert(firstValue, at: parentIndex)
                        expression = parent
                        offset = parentIndex
                        forward()
                    }
                }
            }
        }
        
        private func checkIfTwoExpresionsAreTheSameType(offset: Int) {
            guard let component = expression as? Component else { return }
            guard offset > 0 && offset < component.items.count else { return }
    
            if let firstExpression = component.items[offset - 1] as? Operator, let secondExpression = component.items[offset] as? Operator {
                component.items.remove(at: offset)
            } else if let firstExpression = component.items[offset - 1]  as? Text, let secondExpression = component.items[offset] as? Text {
                let newValue = firstExpression.value + secondExpression.value
                firstExpression.value = newValue
                component.items.remove(at: offset)
            }
        }
        /*
         Check if the expression is a component
            create new component in brackets and check if the indicator is at the beginning, end or in the middle of equation, add new component and set it as the expression
         Check if the expression is a text
            split text value and create two new Text components coresponding to the offset, that cant be on the first character, and place bracket component between them
         */
        func addComponentInBrackets() {
            if let component = expression as? Component {
                let newComponent = Component()
                newComponent.showBrackets = true
                newComponent.parent = component
                
                if offset == component.items.count {
                    component.items.append(newComponent)
                } else if offset < 0 {
                    component.items.insert(newComponent, at: 0)
                } else {
                    component.items[offset].color = UIColor.clear
                    component.items.insert(newComponent, at: offset)
                }
                expression = newComponent
                offset = 0
            } else if let text = expression as? Text {
                guard offset > 0 else { return }
                let firstValue = Text(String(text.value.prefix(offset)))
                firstValue.parent = text.parent
                let secondValue = Text(String(text.value.suffix(text.value.count - offset)))
                secondValue.parent = text.parent
                let newComponent = Component()
                newComponent.showBrackets = true
                newComponent.parent = text.parent
                
                if let parent = text.parent {
                    if let parentIndex = parent.items.firstIndex(where: {$0 === expression}) {
                        parent.items.remove(at: parentIndex)
                        parent.items.insert(secondValue, at: parentIndex)
                        parent.items.insert(newComponent, at: parentIndex)
                        parent.items.insert(firstValue, at: parentIndex)
                        expression = newComponent
                        offset = 0
                    }
                }
            }
        }
        
        /* - check what type the expression is
        - if it is a component check if the indicator is at the end, beginning or in the middle of equation and what type the last item is
        - if it is a text remove the character at offset, and if the value is empty delete the whole text expression ad if the value is not empty and the indicator is not at the beginning of the number move back one spot */
        func delete() {
            if let component = expression as? Component {
                if offset == component.items.count {
                    if let text = component.items.last as? Text {
                        text.value.removeLast()
                        if text.value.isEmpty {
                            offset -= 1
                            component.items.removeLast()
                        }
                    } else if let operatorLast = component.items.last as? Operator {
                        component.items.removeLast()
                        offset -= 1
                    } else if let component = component.items.last as? Component {
                        // TODO - figure out what happens if the last item of component is a component
                        back()
                    }
                } else if offset >= 0 {
                    component.items.remove(at: offset)
                    checkIfTwoExpresionsAreTheSameType(offset: offset)
                    back()
                }
                if component.items.count == 0 {
                    offset = 0
                }
                
            } else if let text = expression as? Text {
                text.value.remove(at: text.value.index(text.value.startIndex, offsetBy: offset))
                if text.value.isEmpty {
                    if let parent = text.parent {
                        if let currentIndex = parent.items.firstIndex(where: { $0 === text }) {
                            parent.items.remove(at: currentIndex)
                            expression = parent
                            offset = currentIndex
                            checkIfTwoExpresionsAreTheSameType(offset: offset)
                            back()
                        }
                    }
                    
                } else if offset != 0 {
                    back()
                }
            }
        }
    }
    
    var expression: Component = Component()
    
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
        case .brackets, . leftBracket, .rightBracket:
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
        }
    }
}

// MARK: - Expressions

extension Equation {
    
    class Expression {
        weak var parent: Component?
        var color: UIColor = UIColor.clear
        
        func generateView() -> UIView? { return nil }
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
        
        override func generateView() -> UIView? {
            let label = UILabel(frame: .zero)
            label.text = {
                switch self.type {
                case .plus: return "+"
                case .minus: return "-"
                }
            }()
            label.sizeToFit()
            label.backgroundColor = color
            return label
        }
    }
    
    class Text: Expression {
        var value: String
        var textRange: NSRange?
        init(_ value: String) {
            self.value = value
        }
        
        override func generateView() -> UIView? {
            let label = UILabel(frame: .zero)
            let atributedString = NSMutableAttributedString(string: value)
            if let range = textRange  {
                atributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.red, range: range)
            }
            label.attributedText = atributedString
            label.backgroundColor = color
            label.sizeToFit()
            return label
        }
    }
    
    class Component: Expression {
        var showBrackets: Bool = false
        var items: [Expression] = [Expression]()
        
        override func generateView() -> UIView? {
            return linearlyLayoutViews(items.map { $0.generateView() }, color: color, brackets: showBrackets)
        }
    }
    
    private static func linearlyLayoutViews(_ inputViews: [UIView?], color: UIColor, brackets: Bool) -> UIView? {
        var views: [UIView] = inputViews.compactMap { $0 }
        if brackets {
            views = addBracketsToView(views: views)
        }
        guard views.count > 0 else { return nil }
        
        
        
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
        return newView
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
}
