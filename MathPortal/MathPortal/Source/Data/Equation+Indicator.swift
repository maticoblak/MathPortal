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
        
        // MARK: - Private functions
        // TODO: have special Container component that just allows one type of expression in it (exp. Lines, Text)
        private func componentIncludesLines(_ component: Component) -> Bool {
            return component.items.contains(where: ({ $0 is Line }))
        }
        
        private var isEquationEmpty: Bool {
            guard let line = expression as? Line else { return false }
            guard line.items.isEmpty || (line.items.count == 1 && line.items.first is Cursor) else { return false }
            guard line.parent?.parent == nil else { return false }
            guard line.parent?.items.count == 1 else { return false }
            return true
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
        
        // MARK: Add indicator
        // TODO - 
        func addIndicator() {
            guard let component = expression as? Component else { return }
            guard isFunction(component) == false else { return }
            guard component.items.contains(where: ({ $0 is Cursor })) == false else { return }
            let cursor = Cursor(parent: component)
            cursor.isSelected = false
            if offset >= component.items.count {
                component.items.append(cursor)
                cursor.isSelected = true
                offset += 1
            } else if offset < 0 {
                component.items.insert(cursor, at: offset + 1)
                cursor.isSelected = true
            } else if component.items[offset] is Empty == false {
                component.items[offset].isSelected = true
                component.items.insert(cursor, at: offset + 1)
            }
        }
        
        // MARK: Remove indicator
        func removeIndicator() {
            guard let component = expression as? Component else { return }
            let index = component.items.firstIndex(where: ({ $0 is Cursor }))
            if let index = index {
                if index <= offset, index != component.items.count {
                    offset -= 1
                }
                component.items.remove(at: index)
                if component.items.isEmpty == false, offset >= 0, offset < component.items.count {
                    component.items[offset].isSelected = false
                }
            }
        }
        
        // MARK: level in
        func levelIn() {
            if let component = expression as? Component {
                guard component.items.count > offset, offset >= 0 else { return }  // if you are at the end of the equation the offset is greater then the index of last element since the last element hasn't ben added yet and similar if you are at the beginning the offset is less than 0
                guard component.items[offset] is Component else { return }
                removeIndicator()
                self.expression = component.items[offset]
                self.expression.isSelected = false
                offset = 0
            
                if let component = expression as? Component {
                    if component.items.isEmpty {
                        return
                    // TODO:
                    // if component has only one element and that element is not empty go level in (don't konw if needed)
                    } else if component.items.count == 1, let secondLevel = component.items[offset] as? Component, (secondLevel is Brackets) == false {
                        levelIn()
                    // if element that indicator is on is a component and it only has one element go in
                    } else if let secondLevel = component.items[offset] as? Component, secondLevel.items.count == 1, (secondLevel is Brackets) == false {
                        levelIn()
                    } else if component.items.count > 0 {
                        component.items[0].isSelected = true
                    }
                }
                addIndicator()
            }
        }
        
        // MARK: Level out
        func levelOut() {
    
            guard let parent = expression.parent else { return }
            guard let index = parent.items.firstIndex(where: {$0 === self.expression}) else { return }
            removeIndicator()
            //remember the current offset
            let currentOffset = self.offset
            
            // change the expression to parent - it does't matter if the offset is greater or les than items count
            self.expression = parent
            parent.items[index].isSelected = true
            self.offset = index
            
            if let component = parent.items[index] as? Component {
                // if the indicator is in the middle of expression its colour has to be set to default
                if currentOffset < component.items.count, currentOffset >= 0 {
                    component.items[currentOffset].isSelected = false
                    
                    // if component has only one element and there are no brackets go out another level
                    if component.items.count == 1, (component is Brackets) == false, (component is Integral) == false, (component is TrigonometricFunc) == false, (component is Line) == false  {
                        levelOut()
                    }
                }
            }
            addIndicator()
        }
        
        // MARK: Forward
        func forward() {
            guard isEquationEmpty == false else {
                return
            }
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
                        component.items[offset-1].isSelected = false
                    }
                    // check if there is a expression and if there is set his background colour (you could be at the end offset >= items.count)
                    if offset < component.items.count {
                        component.items[offset].isSelected = true
                        // TODO: check if == 0 or <= 1
                        if let selectedComponent = component.items[offset] as? Line, selectedComponent.items.count == 0 {
                            levelIn()
                            // if the expression is a component and not a function without brackets and it has one or 0 elements go in another level
                        } else if let selectedComponent = component.items[offset] as? Component, selectedComponent.items.count <= 1, isFunction(selectedComponent) == false, (selectedComponent is Brackets) == false, selectedComponent is Line == false  {
                            levelIn()
                        }
                    }
                // if the indicator is at the end and component has only one element
                } else if component.items.count == 1, (component is Brackets) == false {
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
                
            }
            addIndicator()
        }
        
        // MARK: Back
        func back() {
            guard isEquationEmpty == false else {
                return
            }
            removeIndicator()
            if let component = expression as? Component {
                guard (component is Line && component.items.isEmpty && component.parent?.parent == nil && component.parent?.items.count == 1) == false else {
                    offset = 0
                    addIndicator()
                    return
                }
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
                        component.items[offset + 1].isSelected = false
                    }
                    
                    // check if the indicator landed on expression (offset >= 0) and set it a colour
                    if offset >= 0 {
                        component.items[offset].isSelected = true
                        if let selectedComponent = component.items[offset] as? Line, selectedComponent.items.count == 0 {
                            levelIn()
                        // if the expression is a component without brackets and not a function and it has only one or 0 elements go in another level
                        } else if let selectedComponent = component.items[offset] as? Component, selectedComponent.items.count <= 1, (selectedComponent is Brackets) == false, isFunction(selectedComponent) == false, selectedComponent is Line == false {
                            levelIn()
                        }
                    }
                
                // if the indicator is at the beginning of component ant it has only one element
                } else if component.items.count == 1, (component is Brackets) == false {
                    levelOut()
                    if offset >= 0 {
                        back()
                    }
                // if the indcator is at the beginning of the component
                } else {
                    levelOut()
                }
            }
            addIndicator()
        }
        
        // MARK: New line
        func addNewLine() {
            // New line can only be added in the component
            guard let component = expression as? Component else { return }
            // The new line can be added on top level or in the brackets to make matrix or binomial symbol and of corse the line can be added while the offset is in the line.
            guard expression.parent == nil || (component is Brackets) || component is Line else { return }
            
            removeIndicator()
            
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
                    if let component = expression as? Component {
                        component.addExpression(Line(), at: offset)
                        forward()
                        back()
                    }
                // The indicator is somewhere in the middle of line. In that case some items have to be removed from current line and new lane has to be added with the deleted items.
                } else if let parent = component.parent, let index = parent.items.firstIndex(where: { $0 === component }) {
                    let currentLine = Array(component.items[0...offset])
                    let newLine = Array(component.items[offset + 1..<component.items.count])
                    component.items = currentLine
                    component.items.forEach { $0.parent = component }
                    let line = Line(items: newLine, parent: parent)
                    parent.items.insert(line, at: index + 1)
                    levelOut()
                    forward()
                    levelIn()
                }
            // The indicator is on top level or in brackets component
            } else {
                // Checks if the current component consists of only Line components or not. If it does not that means the indicator is component with brackets and we have to create 2 new lines.
                let alreadyHasLineComponents: Bool = componentIncludesLines(component)

                // The indicator is at the beginning of component
                if offset <= 0 {
                    if alreadyHasLineComponents {
                        component.addExpression(Line(), at: -1)
                    } else {
                        let newItems = [Line(), Line(items: component.items.filter({ $0 is Empty == false }))]
                        component.items = []
                        for index in 0..<newItems.count {
                            component.addExpression(newItems[index], at: index)
                        }
                        
                    }
                    forward()
                // The indicator is at the end of component
                } else if offset == component.items.count {
                    if alreadyHasLineComponents {
                        component.addExpression(Line(), at: offset)
                        levelIn()
                    } else {
                        component.items = []
                        component.addExpression(Line(items: component.items), at: 0)
                        component.addExpression(Line(), at: 1)
                        goToTheEndOfEquation()
                        back()
                    }
                // The indicator is somewhere in the middle of component
                } else {
                    if alreadyHasLineComponents {
                        component.addExpression(Line(), at: offset)
                        forward()
                    } else {
                        let currentLine = Line(items: Array(component.items[0...offset-1]), parent: component)
                        let newLine = Line(items: Array(component.items[offset..<component.items.count]), parent: component)
                        component.items = []
                        component.addExpression(currentLine, at: 0)
                        component.addExpression(newLine, at: 1)
                        goToTheEndOfEquation()
                        back()
                        levelIn()
                    }
                }

            }
            addIndicator()
        }
        
        // MARK: Space
        func addSpace() {
            guard let component = expression as? Component else { return }
            removeIndicator()
            component.addExpression(Space(), at: offset)
            forward()
            addIndicator()
        }
        
        // MARK: String
        func addString(_ value: String) {
            guard let component = expression as? Component else { return }
            removeIndicator()
            let text = Text(value)
            component.addExpression(text, at: offset)
            forward()
            addIndicator()
        }
        
        
        // MARK: Operator
        func addOperator(_ operatorType: Operator.OperatorType) {
            guard let component = expression as? Component else { return }
            removeIndicator()
            let mathOperator = Operator(operatorType)
            component.addExpression(mathOperator, at: offset)
            forward()
            addIndicator()
        }

        private func mergeOperatorsAt(offset: Int) {
            guard let component = expression as? Component else { return }
            guard offset > 0 && offset < component.items.count else { return }
            
            if  component.items[offset - 1] is Operator, component.items[offset] is Operator {
                component.items.remove(at: offset)
            }
        }
        
        // MARK: Component


        func addComponent(_ newComponent: Component) {
            guard let component = expression as? Component else { return }
            removeIndicator()
            component.addExpression(newComponent, at: offset)
            selectComponent(newComponent)
            addIndicator()
        }
        
        private func selectComponent(_ component: Component) {
            if let oldComponent = expression as? Component, offset < oldComponent.items.count, offset >= 0 {
                oldComponent.items[offset].isSelected = false
            }
            self.expression = component
            offset = 0
            if component.items.count >= 0 {
                component.items[0].isSelected = true
            }
        }
        
        /// For adding component to the component that the indicator is on (exponent, index)
        func insertComponent(_ newComponent: Component) {
            // Just possible if we are currently in a componnent
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            newComponent.parent = component
            // The indicator is at the beginning of the expression
            if offset < 0 {
                component.items.insert(newComponent, at: 0)
                forward()
            // The indicator is at the end of expression
            } else if offset == component.items.count {
                component.items.append(newComponent)
            // If the indicator is on Empty expression
            } else if component.items[offset] is Empty {
                component.addExpression(newComponent, at: offset)
            // If the indicator is on any other expression, take that expression, stuck it in the newComponent and make newComponent take its place
            } else {
                component.items[offset].parent = newComponent
                component.items[offset].isSelected = false
                newComponent.addExpression(component.items[offset], at: 0)
                component.items[offset] = newComponent
            }
            levelIn()
            addIndicator()
        }
        
        // MARK: Delete
        func delete() {
            removeIndicator()
            if let component = expression as? Component {
                if isFunction(component) {
                    component.delete(offset: offset)
                    component.items[offset].isSelected = true

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
                    } else if component.items.last is Component {
                        back()
                    } else if component.items.isEmpty == false {
                        component.items.removeLast()
                        offset -= 1
                    }
                // the indicator is somewhere in the middle
                } else if offset >= 0 {
                    // if we have a component with one element that is Empty expression go level out
                    if component.items.count == 1, component.items[0] is Empty {
                        levelOut()
                    } else {
                        component.items.remove(at: offset)
                        // TODO: Check for text components
                        mergeOperatorsAt(offset: offset)
                        // The back acts differently in the line when it is empty
                        if (component is Line) == false || component.items.count != 0 {
                            back()
                        }
                    }
                // if the indicator is at the beginning of the equation
                } else if offset < 0 {
                    // If you are deleting a new line you have to be at the start of the line component (index = -1)
                    if component is Line {
                        levelOut()
                        if offset > 0, let component = expression as? Component, let firstLine = component.items[offset-1] as? Line, let secondLine =  component.items[offset] as? Line {
                            let mergedLine = Line(items: firstLine.items + secondLine.items)
                            mergedLine.parent = component
                            component.addValue(expression: mergedLine, offset: offset-1)
                            delete()
                        } else {
                            levelIn()
                        }
                    } else {
                        levelOut()
                    }
                }
                // Have to remove it again in case it was added in the previous if statement (the indicator is added in levelOut, back ,... functions)
                removeIndicator()
                // after the deletion check if component is empty
                if component.items.isEmpty {
                    // if we have deleted all items in component and the component has brackets it should append empty expression
                    if (component is Brackets) {
                        // TODO: scale???
                        component.addExpression(Empty(), at: 0)
                        offset = 0
                    // if the component does not have brackets (components in fraction)
                    } else if component.parent != nil {
                        levelOut()
                        delete()
                    // the only component that does not have a parent is top level component and it always have at least one line component - after the deletion of all items the offset should be set at 0
                    } else {
                        component.items = []
                        component.addExpression(Line(), at: 0)
                        offset = 0
                        levelIn()
                    }
                }
            } else if let text = expression as? Text {
                text.value.remove(at: text.value.index(text.value.startIndex, offsetBy: offset))
                if text.value.isEmpty {
                    levelOut()
                    delete()
                } else {
                    back()
                }
            }
            addIndicator()
        }
    }
}

