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
        
        private var component: Component
        private var offset: Int = 0
        init(component: Component) {
            self.component = component
            goToTheEndOfEquation()
            back()
            levelIn()
            goToTheEndOfEquation()
        }
        
        // MARK: - Private functions
        // TODO: Have better solution for component with just lines in it
        private func componentIncludesLines(_ component: Component) -> Bool {
            return component.items.contains(where: ({ $0 is Line }))
        }
        
        private func goToTheEndOfEquation() {
            offset = 0
            component.items.forEach { _ in
                forward()
            }
        }
        
        // MARK: Add indicator
        func addIndicator() {
            guard component.items.contains(where: ({ $0 is Cursor })) == false else { return }
            if component.isFunction {
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
            if let index = component.items.firstIndex(where: ({ $0 is Cursor })) {
                if index <= offset, index != component.items.count {
                    offset -= 1
                }
                component.items.remove(at: index)
                if component.items.isEmpty == false, offset >= 0, offset < component.items.count {
                    component.items[offset].isSelected = false
                }
            } else if component.isFunction {
                component.items[offset].isSelected = false
            }
        }
        
        // MARK: level in
        func levelIn() {
            guard component.items.count > offset, offset >= 0 else { return }
            guard let newComponent = component.items[offset] as? Component else { return }
            removeIndicator()
            setCurrentComponent(to: newComponent)
        
            if component.items.isEmpty == false, let secondLevel = component.items[offset] as? ClearComponent, secondLevel.items.count == 1  {
                levelIn()
            }
            addIndicator()
        }
        
        // MARK: Level out
        func levelOut() {
            guard let parent = component.parent else { return }
            guard let expressionOffset = parent.items.firstIndex(where: {$0 === self.component}) else { return }
            removeIndicator()
            setCurrentComponent(to: parent, with: expressionOffset)
            addIndicator()
        }
        
        // MARK: Forward
        func forward() {
            removeIndicator()
            // we don't wan't the indicator to be in the fraction/root after the denominator/radicand
            if component.isFunction, offset == component.items.count - 1 {
                levelOut()
            // if the indicator is somewhere in the middle of component
            } else if offset < component.items.count {
                offset += 1
                if offset < component.items.count, let selectedComponent = component.items[offset] as? ClearComponent, selectedComponent.items.count <= 1 {
                    levelIn()
                }
            // if the indicator is at the end and component has only one element, if the component is line an it is empty
            // parent != nil is important, without it it loops
            } else if component.items.count <= 1, component.parent != nil {
                levelOut()
                forward()
            //if the indicator is at the end of component
            } else {
                levelOut()
            }
            
            if let clearComponent = component as? ClearComponent, offset >= clearComponent.items.count, let lastItem = clearComponent.items.last as? Line, lastItem.items.isEmpty {
                if clearComponent.parent == nil {
                    back()
                } else {
                    forward()
                }
            }
            addIndicator()
        }
        
        // MARK: Back
        func back() {
            removeIndicator()
            // don't wan't to be in fraction/root before the enumerator/index
            if component.isFunction, offset == 0 {
                levelOut()
            //if the component is line an it is empty
            } else if component is Line, component.items.isEmpty {
                levelOut()
                back()
            // if indicator is somewhere in the middle of component
            } else if offset >= 0 {
                offset -= 1
                if offset >= 0, let selectedComponent = component.items[offset] as? ClearComponent, selectedComponent.items.count <= 1 {
                    levelIn()
                }
            // if the indicator is at the beginning of component ant it has only one element
            } else if component.items.count <= 1, component.parent != nil {
                levelOut()
                back()
            // if the indicator is at the beginning of the component
            } else {
                levelOut()
            }
            
            if let clearComponent = component as? ClearComponent, offset < 0, let firstItem = clearComponent.items.first as? Line, firstItem.items.isEmpty {
                if clearComponent.parent == nil {
                    forward()
                } else {
                    back()
                }
            }
            addIndicator()
        }
        
        // MARK: New line
        func addNewLine() {
            // The new line can be added on top level or in the brackets to make matrix or binomial symbol and of corse the line can be added while the offset is in the line.
            removeIndicator()
            // The indicator is in the line
            if component is Line {
                if offset < 0 {
                    levelOut()
                    back()
                    addNewLine()
                } else if offset == component.items.count {
                    levelOut()
                    addNewLine()
                } else if let parent = component.parent, let index = parent.items.firstIndex(where: { $0 === component }) {
                    let currentLine = Array(component.items.prefix(offset + 1))
                    let newLine = Array(component.items[offset + 1..<component.items.count])
                    component.replaceAllItems(with: currentLine)
                    parent.addExpression(Line(items: newLine), at: index)
                    levelOut()
                    forward()
                    levelIn()
                }
            // Indicator is in the base component - (component that holds only lines)
            } else if componentIncludesLines(component) {
                let newLine = Line()
                component.addExpression(newLine, at: offset)
                setCurrentComponent(to: newLine)
            // Indicator is in bracets
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
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            component.addExpression(Space(), at: offset)
            forward()
            addIndicator()
        }
        
        // MARK: String
        func addString(_ value: String) {
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            let text = Text(value)
            component.addExpression(text, at: offset)
            if component.items[offset] is ClearComponent {
                levelIn()
            }
            forward()
            addIndicator()
        }
        
        // MARK: Number
        func addNumber(_ value: String) {
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            component.addExpression(Number(value), at: offset)
            if component.items[offset] is ClearComponent {
                levelIn()
            }
            forward()
            addIndicator()
        }
        
        
        // MARK: Operator
        func addOperator(_ operatorType: Operator.OperatorType) {
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            let mathOperator = Operator(operatorType)
            component.addExpression(mathOperator, at: offset)
            forward()
            addIndicator()
        }
        
        // MARK: Component
        func addComponent(_ newComponent: Component) {
            guard componentIncludesLines(component) == false else { return }
            removeIndicator()
            component.addExpression(newComponent, at: offset)
            setCurrentComponent(to: newComponent)
            addIndicator()
        }
        
        private func setCurrentComponent(to newComponent: Component, with newOffset: Int = 0) {
            self.component = newComponent
            self.offset = newOffset
        }
        
        /// For adding component to the component that the indicator is on (exponent, index, brackets)
        func insertComponent(_ newComponent: Component) {
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
            if component is ClearComponent, component.items.isEmpty {
                if component.parent == nil {
                    let newLine = Line()
                    component.addExpression(newLine, at: 0)
                    setCurrentComponent(to: newLine)
                } else {
                    levelOut()
                    delete()
                }
            } else if component.isFunction {
                component.replaceExpression(at: offset, with: Empty())
            } else if offset >= component.items.count {
                back()
            } else if offset < 0 {
                let currentLine = component
                levelOut()
                if offset > 0, let baseLine = component.items[offset - 1] as? Line {
                    let mergedItems = baseLine.items + currentLine.items
                    baseLine.replaceAllItems(with: mergedItems)
                    delete()
                }
            } else {
                component.items.remove(at: offset)
                if component is ClearComponent, component.items.isEmpty {
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

