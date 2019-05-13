//
//  Equation+Indicator.swift
//  MathPortal
//
//  Created by Petra Čačkov on 10/05/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

extension Equation {

    class Indicator {
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
            self.expression.color = defaultColor
            offset = 0
            if let text = self.expression as? Text {
                text.textRange = NSRange(location: 0, length: 1)
            } else if let component = self.expression as? Component {
                if component.items.count > 0, component.fraction == false {
                    component.items[0].color = selectedColor
                } else if component.fraction == true {
                    guard let enumerator = component.items[0] as? Component else { return }
                    if enumerator.items.count < 2  {
                        
                        levelIn()
                    } else {
                        component.items[0].color = selectedColor
                    }
                    
                }
            }
        }
        func levelOut() {
            guard let parent = expression.parent else { return }
            guard let index = parent.items.firstIndex(where: {$0 === self.expression}) else { return }
            if let text = expression as? Text {
                text.textRange = nil
                self.offset = index
                parent.items[index].color = selectedColor
                self.expression = parent
            } else if let component = expression as? Component {
                if offset < component.items.count, offset >= 0 {
                    component.items[offset].color = defaultColor
                    self.offset = index
                    parent.items[index].color = selectedColor
                    self.expression = parent
                } else if parent.fraction, component.items.count < 2 {
                    self.offset = index
                    self.expression = parent
                    levelOut()
                } else {
                    self.offset = index
                    parent.items[index].color = selectedColor
                    self.expression = parent
                }
            }
        }
        func forward() {
            if let component = expression as? Component {
                if offset < component.items.count {
                    offset += 1
                    if offset - 1 >= 0 {
                        component.items[offset-1].color = defaultColor
                    }
                    if offset < component.items.count {
                        component.items[offset].color = selectedColor
                    }
                } else if let parent = expression.parent {
                    if let currentIndex = parent.items.firstIndex(where: {$0 === expression}) {
                        if currentIndex < parent.items.count {
                            self.offset = currentIndex
                            parent.items[offset].color = selectedColor
                            self.expression = parent
                        }
                    }
                }
            } else if let text = expression as? Text {
                if offset < text.value.count - 1 {
                    offset += 1
                    text.textRange = NSRange(location: offset, length: 1)
                    text.parent?.color = defaultColor
                } else {
                    text.textRange = nil
                    if let parent = expression.parent {
                        if let currentIndex = parent.items.firstIndex(where: { $0 === expression }) {
                            self.expression = parent
                            self.offset = currentIndex + 1
                            if currentIndex < parent.items.count-1 {
                                if let component =  expression as? Component {
                                    component.items[offset].color = selectedColor
                                } else {
                                    expression.color = selectedColor
                                }
                            }
                        }
                    }
                }
            }
        }
        func back() {
            if let component = expression as? Component {
                if offset  >= 0, component.items.isEmpty == false {
                    offset -= 1
                    if offset >= 0 {
                        component.items[offset].color = selectedColor
                    }
                    if offset + 1 < component.items.count {
                        component.items[offset + 1].color = defaultColor
                    }
                } else if let parent = expression.parent {
                    if let currentIndex = parent.items.firstIndex(where: {$0 === expression}) {
                        if currentIndex < parent.items.count {
                            self.offset = currentIndex
                            parent.items[offset].color = selectedColor
                            self.expression = parent
                        }
                    }
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
                                component.items[offset].color = selectedColor
                            } else {
                                expression.color = selectedColor
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
                        component.items[offset].color = defaultColor
                        offset += 1
                    }
                } else if offset <= 0 {
                    if let first = component.items[0] as? Operator {
                        first.type = operatorType
                    } else {
                        component.items.insert({
                            let newExpression = Operator(operatorType)
                            newExpression.parent = component
                            return newExpression
                        }(), at: 0)
                        forward()
                        back()
                    }
                } else if let operatorAtIndex = component.items[offset] as? Operator {
                    operatorAtIndex.type = operatorType
                } else if (component.items[offset - 1] is Operator) == false {
                    component.items.insert({
                        let newExpression = Operator(operatorType)
                        newExpression.parent = component
                        return newExpression
                    }(), at: offset)
                    forward()
                    back()
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
                    component.items[offset].color = defaultColor
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
        
        func addFraction() {
            if let component = expression as? Component {
                let fractionComponent = Component()
                let numerator = Component()
                numerator.parent = fractionComponent
                //numerator.items.append(Text("124"))
                let denominator = Component()
                denominator.parent = fractionComponent
                //denominator.items.append(Text("12"))
                fractionComponent.fraction = true
                fractionComponent.parent = component
                fractionComponent.items.append(numerator)
                fractionComponent.items.append(denominator)
                
                
                if offset == component.items.count {
                    component.items.append(fractionComponent)
                }
            }
            levelIn()
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
    
}
