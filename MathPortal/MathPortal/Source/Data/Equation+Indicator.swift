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
                
            goToTheEndOfEquation()
            back()
            levelIn()
            goToTheEndOfEquation()
        
        }
        
        private func componentIncludesLines(_ component: Component) -> Bool {
            return component.items.contains(where: ({ $0 is Line }))
        }
        
        private func goToTheEndOfEquation() {
            guard let component = expression as? Component else { return }
            offset = 0
            component.items.forEach { _ in
                forward()
            }
        }
        
        private func isFunction(_ component: Component?) -> Bool {
            if (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm || component is TrigonometricFunc || component is Integral || component is Limit || component is Series) {
                return true
            } else {
                return false
            }
        }
        
        private func addIndicator() {
            guard let component = expression as? Component else { return }
            guard component.items.contains(where: ({ $0 is Cursor })) == false else { return }
            print(component, component.items, offset)
            let cursor = Cursor(parent: component)
            if offset >= component.items.count {
                component.items.append(cursor)
                offset += 1
            } else {
                component.items.insert(cursor, at: offset + 1)
            }
            print(component, component.items, offset)
        }
        
        private func removeIndicator() {
            guard let component = expression as? Component else { return }
            print(component, component.items, offset)
            let index = component.items.firstIndex(where: ({ $0 is Cursor }))
            if let index = index {
                if index <= offset, index != component.items.count {
                    offset -= 1
                }
                component.items.remove(at: index)
            }
            print(component, component.items, offset)
        }
        
        func levelIn() {
            if let component = expression as? Component {
                guard component.items.count > offset, offset >= 0 else { return }  // if you are at the end of the equation the offset is greater then the index of last element since the last element hasn't ben added yet and similar if you are at the beginning the offset is less than 0
                guard (component.items[offset] as? Operator == nil), component.items[offset] as? Empty == nil, component.items[offset] as? Cursor == nil  else { return }
                removeIndicator()
                self.expression = component.items[offset]
                self.expression.color = defaultColor
                offset = 0
                
                if let text = self.expression as? Text {
                    text.textRange = NSRange(location: 0, length: 1)
                } else if let component = expression as? Component {
                    if component.items.isEmpty {
                        return
                    
                    // if component has only one element and that element is not empty go level in (don't konw if needed)
                    } else if component.items.count == 1, let secondLevel = component.items[offset] as? Component, secondLevel.hasBrackets == false {
                        levelIn()
                    // if element that indicator is on is a component and it only has one element go in
                    } else if let secondLevel = component.items[offset] as? Component, secondLevel.items.count == 1, secondLevel.hasBrackets == false {
                        levelIn()
                    } else if component.items.count > 0 {
                        component.items[0].color = selectedColor
                    }
                }
                addIndicator()
            }
        }
        
        func levelOut() {

            removeIndicator()
            guard let parent = expression.parent else { return }
            guard let index = parent.items.firstIndex(where: {$0 === self.expression}) else { return }
            
            //remember the current offset
            let currentOffset = self.offset
            
            // change the expression to parent - it does't matter if the offset is greater or les than items count
            self.expression = parent
            parent.items[index].color = selectedColor
            self.offset = index
            
            if let text = parent.items[index] as? Text {
                text.textRange = nil
            } else if let component = parent.items[index] as? Component {
                // if the indicator is in the middle of expression its colour has to be set to default
                if currentOffset < component.items.count, currentOffset >= 0 {
                    component.items[currentOffset].color = defaultColor
                    
                    // if component has only one element and there are no brackets go out another level
                    if component.items.count == 1, component.hasBrackets == false, (component is Integral) == false, (component is TrigonometricFunc) == false, (component is Line) == false  {
                        levelOut()
                    }
                }
            }
            addIndicator()
        }
        
        func forward() {

            removeIndicator()
            if let component = expression as? Component {
                // if the indicator is on denominator/radicant go to whole fraction/root - we don't wan't the indicator to be in the fraction/root after the denominator/radicant
                if isFunction(component), offset == component.items.count - 1 {
                    levelOut()
                // if component only has Empty expression in items - don't want to be in front or behinde it
                } else if component.items.count == 1, component.items.first is Empty {
                    levelOut()
                // if the indicator is somwhere in the middle of component
                } else if offset < component.items.count {
                    offset += 1
                    // check if there is a previous expression and set its colour to default (you could be at the beginning of component offset < 0)
                    if offset - 1 >= 0 {
                        component.items[offset-1].color = defaultColor
                    }
                    // check if there is a expression and if there is set his background colour (you could be at the end offset >= items.count)
                    if offset < component.items.count {
                        component.items[offset].color = selectedColor
                        
                        if let selectedComponent = component.items[offset] as? Line, selectedComponent.items.count == 0 {
                            levelIn()
                            // if the expression is a component and not a function without brackets and it has one or 0 elements go in another level
                        } else if let selectedComponent = component.items[offset] as? Component, selectedComponent.items.count <= 1, isFunction(selectedComponent) == false, selectedComponent.hasBrackets == false, selectedComponent is Line == false  {
                            levelIn()
                        }
                    }
                // if the indicator is at the end and component has only one element
                } else if component.items.count == 1, component.hasBrackets == false {
                    levelOut()
                    if let component = expression as? Component, component.items.count > offset {
                        forward()
                    }
                //if the component is line an it is empty
                } else if component is Line, component.items.isEmpty {
                    levelOut()
                    forward()
                //if the indicator is at the end of component
                } else {
                    levelOut()
                }
                
            } else if let text = expression as? Text {
                if offset < text.value.count - 1 {
                    offset += 1
                    text.textRange = NSRange(location: offset, length: 1)
                } else {
                    levelOut()
                    forward()
                }
            }
            addIndicator()
        }
        
        func back() {

            removeIndicator()
            if let component = expression as? Component {
                //guard component.items.isEmpty == false else { return }
                // if the indicator is on enumerator/index go to whole fraction/root - don't wan't to be in fraction/root before the enumerator/index
                if isFunction(component), offset == 0 {
                    levelOut()
                // if component only has Empty expression in items - don't want to be in front or behinde it
                } else if component.items.count == 1, component.items.first is Empty {
                    levelOut()
                //if the component is line an it is empty
                } else if component is Line, component.items.isEmpty {
                    levelOut()
                    back()
                // if indicator is somwheare in the middle of component
                } else if offset >= 0 {
                    offset -= 1
                    
                    // check if there exist a prvious expression (the indicator could have been at the end of component) and set its colour to default)
                    if offset + 1 < component.items.count {
                        component.items[offset + 1].color = defaultColor
                    }
                    
                    // check if the indicator landed on expression (offset >= 0) and set it a colour
                    if offset >= 0 {
                        component.items[offset].color = selectedColor
                        if let selectedComponent = component.items[offset] as? Line, selectedComponent.items.count == 0 {
                            levelIn()
                        // if the expression is a component without brackets and not a function and it has only one or 0 elements go in another level
                        } else if let selectedComponent = component.items[offset] as? Component, selectedComponent.items.count <= 1, selectedComponent.hasBrackets == false, isFunction(selectedComponent) == false, selectedComponent is Line == false {
                            levelIn()
                        }
                    }
                
                // if the indicator is at the beginning of component ant it has only one element
                } else if component.items.count == 1, component.hasBrackets == false {
                    levelOut()
                    if offset >= 0 {
                        back()
                    }
                // if the indcator is at the beginning of the component
                } else {
                    levelOut()
                }
            } else if let text = expression as? Text {
                if offset > 0 {
                    offset -= 1
                    text.textRange = NSRange(location: offset, length: 1)
                } else {
                    levelOut()
                    back()
                }
            }
            addIndicator()
        }
        
        func addNewLine() {
            // New line can only be added in the component
            guard let component = expression as? Component else { return }
            // The new line can be added on top level or in the brackets to make matrix or binomial symbol and of corse the line can be added while the offset is in the line.
            guard expression.parent == nil || component.hasBrackets || component is Line else { return }
            
            // The indicator is in the line
            if component is Line {
                // The indicator is at the beginning of the line
                if offset <= 0 {
                    levelOut()
                    addNewLine()
                // The indicator is at the end of the line
                } else if offset == component.items.count {
                    levelOut()
                    forward()
                    guard let component = expression as? Component else { return }
                    component.items.insert(Line(parent: component), at: offset)
                    forward()
                    back()
                // The indicator is somewhere in the middle of line. In that case some items have to be removed from current line and new lane has to be added with the deleted items.
                } else {
                    let currentLine = Array(component.items[0...offset-1])
                    let newLine = Array(component.items[offset..<component.items.count])
                    component.items = currentLine
                    component.items.forEach { $0.parent = component }
                    levelOut()
                    forward()
                    guard let component = expression as? Component else { return }
                    let line = Line(items: newLine, parent: component)
                    component.items.insert(line, at: offset)
                    forward()
                    back()
                    levelIn()

                }
            // The indicator is on top level or in brackets component
            } else {
                // Checks if the current component consists of only Line components or not. If it does not that means the indicator is component with brackets and we have to create 2 new lines.
                let alreadyHasLineComponents: Bool = component.items.allSatisfy { $0 is Line }

                // The indicator is at the beginning of component
                if offset <= 0 {
                    if alreadyHasLineComponents {
                        component.items.insert(Line(parent: component), at: 0)
                    } else {
                        component.items = [Line(parent: component), Line(items: component.items.filter({ $0 is Empty == false }), parent: component)]
                    }
                    forward()
                // The indicator is at the end of component
                } else if offset == component.items.count {
                    if alreadyHasLineComponents {
                        component.items.insert(Line(parent: component), at: offset)
                        levelIn()
                    } else {
                        component.items = [Line(items: component.items, parent: component), Line(parent: component)]
                        goToTheEndOfEquation()
                        back()
                    }
                // The indicator is somwheare in the middle of component
                } else {
                    if alreadyHasLineComponents {
                        component.items.insert(Line(parent: component), at: offset)
                        forward()
                    } else {
                        let currentLine = Line(items: Array(component.items[0...offset-1]), parent: component)
                        let newLine = Line(items: Array(component.items[offset..<component.items.count]), parent: component)
                        component.items = [currentLine, newLine]
                        goToTheEndOfEquation()
                        back()
                        levelIn()
                    }
                }

            }

        }
        
        func addSpace() {
            let space = Space()
            if let component = expression as? Component {
                guard componentIncludesLines(component) == false else { return }
                space.parent = component
                //The indocator is at the beginning of equation
                if offset < 0 {
                    component.items.insert(space, at: 0)
                // The indicator is at the end of equation
                } else if offset == component.items.count {
                    component.items.insert(space, at: offset)
                    forward()
                // the indicator is on empty field
                } else if component.items[offset] is Empty {
                    // if the component is special component
                    if isFunction(component) {
                        component.addValue(expression: space, offset: offset)
                        levelIn()
                        forward()
                    } else {
                        component.items[offset] = space
                        forward()
                    }
                // If the indicator is in the middle of equation (not on empty)
                } else {
                    component.items.insert(space, at: offset)
                    forward()
                }
                
            } else if let text = expression as? Text {
                // the space will be added before the character that indicator is on so we have to guard that we are not on first character
                guard offset > 0, let component = expression as? Component else { return }
                space.parent = text.parent
        
                // separate the current text - has to be set before level out is called because of offset
                let firstValue = Text(String(text.value.prefix(offset)), parent: text.parent)
                let secondValue = Text(String(text.value.suffix(text.value.count - offset)), parent: text.parent)
                
                levelOut()

                // replace the current text with separated text and space in between
                component.items[offset] = secondValue
                component.items.insert(space, at: offset)
                component.items.insert(firstValue, at: offset)
                forward()
                forward()
                
            }
        }
        
        func addString(_ value: String?) {
            guard let value = value else { return }
            removeIndicator()
            let textValue: Text = {
                let newExpression = Text(value)
                return newExpression
            }()
            if let component = expression as? Component {
                guard componentIncludesLines(component) == false else {
                    addIndicator()
                    return
                }
                textValue.parent = component
                
                // the indicator is at the end of component
                if offset == component.items.count {
                    if let text = component.items.last as? Text {
                        text.value += value
                    // you can't add integeer to fraction since it has exactly 2 components in items
                    } else if component is Fraction == false {
                        component.items.append(textValue)
                        forward()
                    }
                // the indicator is at the beginning of component
                } else if offset < 0 {
                    if let text = component.items[0] as? Text {
                        text.value.insert(Character(value), at: text.value.startIndex)
                    // you can't add integeer to fraction since it has exactly 2 components in items
                    } else if component is Fraction == false {
                        component.items.insert(textValue, at: 1)
                        checkIfTwoExpresionsAreTheSameType(offset: 2)
                    }
                // the indicator is on empty field
                } else if component.items[offset] is Empty {
                    // if the componet is special component
                    if isFunction(component) {
                        component.addValue(expression: textValue, offset: offset)
                        levelIn()
                        forward()
                    } else {
                        component.items[offset] = textValue
                        forward()
                    }
                // the indicator is in the middle of equation
                } else {
                    if let text = component.items[offset] as? Text {
                        text.value += value
                    } else {
                        guard isFunction(component) == false else { return }
                        component.items.insert(textValue, at: offset + 1)
                        checkIfTwoExpresionsAreTheSameType(offset: offset + 2)
                    }
                }
            } else if let text = expression as? Text {
                text.value.insert(Character(value), at: text.value.index(text.value.startIndex, offsetBy: offset))
                forward()
            }
            addIndicator()
        }
        
        func addOperator(_ operatorType: Operator.OperatorType) {
            if let component = expression as? Component {
                guard componentIncludesLines(component) == false else { return }
                let newOperator = Operator(operatorType, parent: component)
                
                // if we are at the end of component
                if offset == component.items.count {
                    if let last = component.items.last as? Operator {
                        last.type = operatorType
                    } else {
                        component.items.append(newOperator)
                        forward()
                    }
                // if the indicator is at the beginning of the component
                } else if offset < 0 {
                    if let first = component.items.first as? Operator {
                        first.type = operatorType
                    } else {
                        component.items.insert(newOperator, at: 0)
                    }
                // if indicator is in the middle of component and on operator
                } else if let operatorAtIndex = component.items[offset] as? Operator {
                    operatorAtIndex.type = operatorType
                // if the indicator is on empty field
                } else if component.items[offset] is Empty {
                    if isFunction(component) {
                        component.addValue(expression: newOperator, offset: offset)
                        levelIn()
                        forward()
                    } else {
                        component.items[offset] = newOperator
                        forward()
                    }
                // TODO: figure out what happens if the indicator is on expression
                //right now if the expression before the indicator is not an operator the operator is added
                } else if  offset > 0, (component.items[offset - 1] is Operator) == false {
                    // We dont want to add an item in the special component, because they have a specific number of components (fraction: enumerator, denominator)
                    guard isFunction(component) == false else { return }
                    component.items.insert(newOperator, at: offset)
                    forward()
                }
                
            } else if let text = expression as? Text {
                // the operator will be added before the character that indicator is on so we gave to gard that we are not on first character
                guard offset > 0,  let component = expression as? Component else { return }
                let newOperator = Operator(operatorType, parent: text.parent)
                // separate the current text
                let firstValue = Text(String(text.value.prefix(offset)), parent: text.parent)
                let secondValue = Text(String(text.value.suffix(text.value.count - offset)), parent: text.parent)
            
                levelOut()
                // replace the current text with separated txt and operator in between
                component.items[offset] = secondValue
                component.items.insert(newOperator, at: offset)
                component.items.insert(firstValue, at: offset)
                forward()
            }
        }

        func checkIfTwoExpresionsAreTheSameType(offset: Int) {
            guard let component = expression as? Component else { return }
            guard offset > 0 && offset < component.items.count else { return }
            
            if  component.items[offset - 1] is Operator, component.items[offset] is Operator {
                component.items.remove(at: offset)
            } else if let firstExpression = component.items[offset - 1]  as? Text, let secondExpression = component.items[offset] as? Text {
                let newValue = firstExpression.value + secondExpression.value
                firstExpression.value = newValue
                component.items.remove(at: offset)
            }
        }
        
        // component can be regular component or special cases like fraction
        func addComponent(_ newComponent: Component = Component(items: [Empty()]), brackets: Component.BracketsType = .none) {
            newComponent.brackets = brackets
            if let component = expression as? Component {
                guard componentIncludesLines(component) == false else { return }
                newComponent.parent = component
                // if the indicator is at the end of component
                if offset == component.items.count {
                    component.items.append(newComponent)
                // if the indicator is at the beginning of component
                } else if offset < 0 {
                    component.items.insert(newComponent, at: 0)
                } else if component.items[offset] is Empty  {
                    if isFunction(component) {
                        component.addValue(expression: newComponent, offset: offset)
                        // Probably not needed
                        levelIn()
                    } else {
                        component.items[offset] = newComponent
                    }
                } else {
                    guard isFunction(component) == false else { return }
                    component.items[offset].color = defaultColor
                    component.items.insert(newComponent, at: offset)
                }
                levelIn()
            } else if let text = expression as? Text {
                guard offset > 0 else { return }
                newComponent.parent = text.parent
                let firstValue = Text(String(text.value.prefix(offset)))
                firstValue.parent = text.parent
                let secondValue = Text(String(text.value.suffix(text.value.count - offset)))
                secondValue.parent = text.parent
                
                levelOut()
                if let component = expression as? Component {
                    component.items[offset] = secondValue
                    component.items.insert(newComponent, at: offset)
                    component.items.insert(firstValue, at: offset)
                    forward()
                }
            }
        }

        /// For adding component to the component that the indicator is on (exponent, index)
        func insertComponent(_ newComponent: Component) {
            // Just possible if we are currently in a componnent
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            newComponent.parent = component
            // The indicator is at the beginning of the expression
            if offset < 0 {
                component.items.insert(newComponent, at: 0)
            // The indicator is at the end of expression
            } else if offset == component.items.count {
                component.items.append(newComponent)
            // If the indicator is on Empty expression
            } else if component.items[offset] is Empty {
                component.addValue(expression: newComponent, offset: offset)
            // If the indicator is on any other expression, take that expression, stuck it in the newComponent and make newComponent take its place
            } else {
                component.items[offset].parent = newComponent
                component.items[offset].color = .clear
                newComponent.addValue(expression: component.items[offset], offset: 0)
                component.items[offset] = newComponent
            }
            levelIn()
        }
        
        func delete() {
            if let component = expression as? Component {
                if isFunction(component) {
                    component.delete(offset: offset)
                    component.items[offset].color = selectedColor

                // if the indicator is at the end of the component
                } else if offset == component.items.count {
                    // if the last item is text delete each character separately
                    if let text = component.items.last as? Text {
                        text.value.removeLast()
                        // if the Text expression is empty delete it
                        if text.value.isEmpty {
                            offset -= 1
                            component.items.removeLast()
                        }
                    } else if component.items.last is Operator {
                        component.items.removeLast()
                        offset -= 1
                    } else if component.items.last is Component {
                        back()
                    }
                // the indicator is somwheare in the middle
                } else if offset >= 0 {
                    // if we have an component with one element that is Empty expression go level out
                    if component.items.count == 1, component.items[0] is Empty {
                        levelOut()
                    } else {
                        component.items.remove(at: offset)
                        checkIfTwoExpresionsAreTheSameType(offset: offset)
                        // The back acts differently in the line when it is empty
                        if (component is Line) == false || component.items.count != 0 {
                            back()
                        }
                    }
                // if the indicator is at the beginning of the equation
                } else if offset < 0 {
                    // If you are deleting a new line space you have to be at the start of the line component (index = -1)
                    if component is Line {
                        levelOut()
                        guard offset > 0 else { return }
                        guard let component = expression as? Component, let firstLine = component.items[offset-1] as? Line, let secondLine =  component.items[offset] as? Line else { return }
                        let mergedLine = Line(items: firstLine.items + secondLine.items)
                        mergedLine.parent = component
                        component.addValue(expression: mergedLine, offset: offset-1)
                        delete()
                    } else {
                        levelOut()
                    }
                }
                // after the deletion check if component is empty
                if component.items.isEmpty {
                    // if we have deleted all items in component and the component has brackets it should append empty expression
                    if  component.hasBrackets == true {
                        component.items.append(Empty(parent: component, selectedColor: selectedColor))
                        offset = 0
                    // if the component does not have brackets (components in fraction)
                    } else if component.parent != nil {
                        levelOut()
                        delete()
                    // the only component that does not have a parent is top level component and it always have et leat on line component - after the deletion of all items the offset should be set at 0
                    } else {
                        let line = Line(parent: component)
                        component.items = [line]
                        offset = 0
                        levelIn()
                    }
                }
            } else if let text = expression as? Text {
                text.value.remove(at: text.value.index(text.value.startIndex, offsetBy: offset))
                if text.value.isEmpty {
                    levelOut()
                    if let component = expression as? Component {
                        component.items.remove(at: offset)
                        checkIfTwoExpresionsAreTheSameType(offset: offset)
                    }
                }
                back()
            }
        }
    }
}

