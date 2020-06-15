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
            if (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm || component is TrigonometricFunc || component is Integral || component is Limit || component is Series || component is Brackets) {
                return true
            } else {
                return false
            }
        }
        
        // MARK: Add indicator
        func addIndicator() {
            guard let component = expression as? Component else { return }
            guard component.items.contains(where: ({ $0 is Cursor })) == false else { return }
            if isFunction(component) {
                guard  component.items.isEmpty == false, component.items.count > offset, offset >= 0 else { return }
                component.items[offset].isSelected = true
            } else {
                let cursor = Cursor()
                if offset >= component.items.count {
                    cursor.isSelected = true
                    offset += 1
                } else if offset < 0 {
                    cursor.isSelected = true
                } else {
                    component.items[offset].isSelected = true
                }
                component.addExpression(cursor, at: offset)
            }
        }
        
        // MARK: Remove indicator
        func removeIndicator() {
            guard let component = expression as? Component else { return }
            if let index = component.items.firstIndex(where: ({ $0 is Cursor })) {
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
                guard let newComponent = component.items[offset] as? Component else { return }
                removeIndicator()
                setCurrentComponent(to: newComponent)
            
                if let component = expression as? Component, component.items.isEmpty == false  {
                    if let secondLevel = component.items[offset] as? ClearComponent, secondLevel.items.count == 1 {
                        levelIn()
                    }
                }
                addIndicator()
            }
        }
        
        // MARK: Level out
        func levelOut() {
    
            guard let parent = expression.parent else { return }
            guard let expressionOffset = parent.items.firstIndex(where: {$0 === self.expression}) else { return }
            // TODO guard if it is empty line
            removeIndicator()
            setCurrentComponent(to: parent, with: expressionOffset)
            addIndicator()
        }
        
        // MARK: Forward
        func forward() {
            removeIndicator()
            if let component = expression as? Component {
                // if the indicator is on denominator/radicant go to whole fraction/root - we don't wan't the indicator to be in the fraction/root after the denominator/radicant
                if isFunction(component), offset == component.items.count - 1 {
                    levelOut()
                // if the indicator is somwhere in the middle of component
                } else if offset < component.items.count {
                    offset += 1
                    // check if there is a expression and if there is set his background colour (you could be at the end offset >= items.count)
                    if offset < component.items.count {
                        // TODO: check if == 0 or <= 1
                        if let selectedComponent = component.items[offset] as? ClearComponent, selectedComponent.items.count <= 1 {
                            levelIn()
                        }
                    }
                // if the indicator is at the end and component has only one element //if the component is line an it is empty
                    // parent != nil is important, without it it loops
                } else if component.items.count <= 1, component.parent != nil {
                    levelOut()
                    forward()
                //if the indicator is at the end of component
                } else {
                    levelOut()
                }
                
                if let clearComponent = expression as? ClearComponent, offset >= clearComponent.items.count, let lastItem = clearComponent.items.last as? Line, lastItem.items.isEmpty {
                    if clearComponent.parent == nil {
                        back()
                    } else {
                        forward()
                    }
                    
                }
       
            }
            addIndicator()
        }
        
        // MARK: Back
        func back() {
            removeIndicator()
            if let component = expression as? Component {
                // if the indicator is on enumerator/index go to whole fraction/root - don't wan't to be in fraction/root before the enumerator/index
                if isFunction(component), offset == 0 {
                    levelOut()
                //if the component is line an it is empty
                } else if component is Line, component.items.isEmpty {
                    levelOut()
                    back()
                // if indicator is somwheare in the middle of component
                } else if offset >= 0 {
                    offset -= 1
                    // check if the indicator landed on expression (offset >= 0) and set it a colour
                    if offset >= 0 {
                        if let selectedComponent = component.items[offset] as? ClearComponent, selectedComponent.items.count <= 1 {
                            levelIn()
                        }
                    }
                // if the indicator is at the beginning of component ant it has only one element
                } else if component.items.count <= 1, component.parent != nil {
                    levelOut()
                    back()
                // if the indcator is at the beginning of the component
                } else {
                    levelOut()
                }
                
                if let clearComponent = expression as? ClearComponent, offset < 0, let firstItem = clearComponent.items.first as? Line, firstItem.items.isEmpty {
                    if clearComponent.parent == nil {
                        forward()
                    } else {
                        back()
                    }
                }
            }
            addIndicator()
        }
        
        // MARK: New line
        func addNewLine() {
            // New line can only be added in the component
            guard let component = expression as? Component else { return }
            // The new line can be added on top level or in the brackets to make matrix or binomial symbol and of corse the line can be added while the offset is in the line.
            removeIndicator()
            // The indicator is in the line
            if component is Line {
                // The indicator is at the beginning of the line
                if offset < 0 {
                    levelOut()
                    back()
                    addNewLine()
                // The indicator is at the end of the line
                } else if offset == component.items.count {
                    levelOut()
                    addNewLine()
                // The indicator is somewhere in the middle of line. In that case some items have to be removed from current line and new lane has to be added with the deleted items.
                } else if let parent = component.parent, let index = parent.items.firstIndex(where: { $0 === component }) {
                    let currentLine = Array(component.items.prefix(offset + 1))
                    let newLine = Array(component.items[offset + 1..<component.items.count])
                    component.replaceAllItems(with: currentLine)
                    parent.addExpression(Line(items: newLine), at: index)
                    levelOut()
                    forward()
                    levelIn()
                }
            } else if componentIncludesLines(component) {
                let newLine = Line()
                component.addExpression(newLine, at: offset)
                setCurrentComponent(to: newLine)
            } else if component.parent is Brackets {
                if offset < 0 {
                    component.replaceAllItems(with: [Line(), Line(items: component.items)])
                    forward()
                } else if offset == component.items.count {
                    component.replaceAllItems(with: [Line(items: component.items), Line()])
                    goToTheEndOfEquation()
                    back()
                } else {
                    let currentLine = Line(items: Array(component.items.prefix(offset + 1)))
                    let newLine = Line(items: Array(component.items[offset + 1..<component.items.count]))
                    component.replaceAllItems(with: [currentLine, newLine])
                    goToTheEndOfEquation()
                    back()
                    levelIn()
                }
            }
            addIndicator()
        }
        
        // MARK: Space
        func addSpace() {
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            component.addExpression(Space(), at: offset)
            forward()
            addIndicator()
        }
        
        // MARK: String
        func addString(_ value: String) {
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            let text = Text(value)
            component.addExpression(text, at: offset)
            levelIn()
            forward()
            addIndicator()
        }
        
        // MARK: Number
        func addNumber(_ value: String) {
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            component.addExpression(Number(value), at: offset)
            levelIn()
            forward()
            addIndicator( )
        }
        
        
        // MARK: Operator
        func addOperator(_ operatorType: Operator.OperatorType) {
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            let mathOperator = Operator(operatorType)
            component.addExpression(mathOperator, at: offset)
            forward()
            addIndicator()
        }
        
        // MARK: Component


        func addComponent(_ newComponent: Component) {
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            component.addExpression(newComponent, at: offset)
            setCurrentComponent(to: newComponent)
            addIndicator()
        }
        
        private func setCurrentComponent(to component: Component, with newOffset: Int = 0) {
            if let oldComponent = expression as? Component, offset < oldComponent.items.count, offset >= 0 {
                oldComponent.items[offset].isSelected = false
            }
            self.expression = component
            self.offset = newOffset
        }
        
        /// For adding component to the component that the indicator is on (exponent, index, brackets)
        func insertComponent(_ newComponent: Component) {
            guard let component = expression as? Component else { return }
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            if offset < 0 || offset >= component.items.count || component.items[offset] is Empty {
                component.addExpression(newComponent, at: offset)
                setCurrentComponent(to: newComponent)
            } else {
                newComponent.addExpression(component.items[offset], at: 0)
                component.replaceExpression(at: offset, with: newComponent)
                levelIn()
                forward()
            }
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
                            component.replaceExpression(at: offset - 1, with: mergedLine)
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

