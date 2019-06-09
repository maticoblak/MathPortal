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
            if let component = expression as? Component {
                guard component.items.count > offset, offset >= 0 else { return }  // if you are at the end of the equation the offset is greater then the index of last element since the last element hasn't ben added yet and similar if you are at the beginning the offset is less than 0
                guard (component.items[offset] as? Operator == nil), component.items[offset] as? Empty == nil else { return }
                self.expression = component.items[offset]
                self.expression.color = defaultColor
                offset = 0
                
                if let text = self.expression as? Text {
                    text.textRange = NSRange(location: 0, length: 1)
                } else if let component = expression as? Component {
                    // if component has only one element and that element is not empty go level in (don't konw if needed)
                    if component.items.count == 1, let secondLevel = component.items[offset] as? Component, secondLevel.showBrackets == false {
                        levelIn()
                    // if element that indicator is on is a component and it only has one element go in
                    } else if let secondLevel = component.items[offset] as? Component, secondLevel.items.count == 1, secondLevel.showBrackets == false {
                        levelIn()
                    } else if component.items.count > 0 {
                        component.items[0].color = selectedColor
                    }
                }
            }
        }
        
        func levelOut() {
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
                // if the indicator is in th middle of expression its colour has to be set to default
                if currentOffset < component.items.count, currentOffset >= 0 {
                    component.items[currentOffset].color = defaultColor
                    
                    // if component has only one element and there are no brackets go out another level
                    if component.items.count == 1, component.showBrackets == false {
                        levelOut()
                    }
                }
            }
        }
        func forward() {
            if let component = expression as? Component {
                
                // if the indicator is on denominator/radicant go to whole fraction/root - we don't wan't the indicator to be in the fraction/root after the denominator/radicant
                if (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm), offset == component.items.count - 1 {
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
                        // if the expression is a component without brackets and it has only one element go in another level
                        if let selectedComponent = component.items[offset] as? Component, selectedComponent.items.count == 1, selectedComponent.showBrackets == false {
                            levelIn()
                        }
                    }
                // if the indicator is at the end and component has only one element
                } else if component.items.count == 1, component.showBrackets == false {
                    levelOut()
                    if let component = expression as? Component, component.items.count > offset {
                        forward()
                    }
                // if the indicator is at the end of component
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
        }
        
        func back() {
            if let component = expression as? Component {
                // if the indicator is on enumerator/index go to whole fraction/root - don't wan't to be in fraction/root before the enumerator/index
                if (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm), offset == 0 {
                    levelOut()
                // if component only has Empty expression in items - don't want to be in front or behinde it
                } else if component.items.count == 1, component.items.first is Empty {
                    levelOut()
                // if indicator is somwheare in the middle of component
                } else if offset  >= 0/*, component.items.isEmpty == false*/ {
                    offset -= 1
                    
                    // check if there exist a prvious expression (the indicator could have been at the end of component) and set its colour to default)
                    if offset + 1 < component.items.count {
                        component.items[offset + 1].color = defaultColor
                    }
                    
                    // check if the indicator landed on expression (offset >= 0) and set it a colour
                    if offset >= 0 {
                        component.items[offset].color = selectedColor
                        // if the expression is a component without brackets and it has only one element go in another level
                        if let selectedComponent = component.items[offset] as? Component, selectedComponent.items.count == 1, selectedComponent.showBrackets == false {
                            levelIn()
                        }
                    }
                
                // if the indicator is at the beginning of component ant it has only one element
                } else if component.items.count == 1, component.showBrackets == false {
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
        }

        func addInteger(value: String?) {
            guard let value = value else { return }
            let textValue: Text = {
                let newExpression = Text(value)
                return newExpression
            }()
            if let component = expression as? Component {
                textValue.parent = component
                textValue.scale = adjustScale(expression: textValue)
                
                // the indicator is at the end of component
                if offset == component.items.count {
                    if let text = component.items.last as? Text {
                        text.value += value
                    // you can't add integeer to fraction since it has exactly 2 components in items
                    } else if component is Fraction == false {
                        component.items.append(textValue)
                        offset += 1
                    }
                // the indicator is at the beginning of component
                } else if offset < 0 {
                    if let text = component.items[0] as? Text {
                        text.value.insert(Character(value), at: text.value.startIndex)
                    // you can't add integeer to fraction since it has exactly 2 components in items
                    } else if component is Fraction == false {
                        component.items.insert(textValue, at: 0)
                    }
                // the indicator is on empty field
                } else if component.items[offset] is Empty {
                    // if the componet is special component
                    if component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm{
                        component.addValue(expression: textValue, offset: offset)
                        levelIn()
                        forward()
                    } else {
                        component.items[offset] = textValue
                        forward()
                    }
                } else {
                    guard (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm) == false else { return }
                    // TODO: What happens if you want to add text in the middle
                }
            } else if let text = expression as? Text {
                text.value.insert(Character(value), at: text.value.index(text.value.startIndex, offsetBy: offset))
                forward()
            }
        }
        
        func addOperator(_ operatorType: Operator.OperatorType) {
            
            let newOperator = Operator(operatorType)
            
            if let component = expression as? Component {
                newOperator.parent = component
                newOperator.scale = adjustScale(expression: newOperator)
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
                    if component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm {
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
                    guard (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm) == false else { return }
                    component.items.insert(newOperator, at: offset)
                    forward()
                }
                
            } else if let text = expression as? Text {
                // the operator will be added before the character that indicator is on so we gave to gard that we are not on first character
                guard offset > 0 else { return }
                newOperator.parent = text.parent
                newOperator.scale = text.scale
                // separate the current text
                let firstValue = Text(String(text.value.prefix(offset)))
                firstValue.parent = text.parent
                firstValue.scale = text.scale
                let secondValue = Text(String(text.value.suffix(text.value.count - offset)))
                secondValue.parent = text.parent
                secondValue.scale = text.scale
                levelOut()
                // if the parent was a component replae the current text with separated txt and operator in between
                if let component = expression as? Component {
                    component.items[offset] = secondValue
                    component.items.insert(newOperator, at: offset)
                    component.items.insert(firstValue, at: offset)
                    forward()
                }
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
        func addComponent(_ newComponent: Component = Component(items: [Empty()]), brackets: Bool ) {
            newComponent.showBrackets = brackets
            if let component = expression as? Component {
                newComponent.parent = component
                newComponent.scale = adjustScale(expression: newComponent)
                // if the indicator is at the end of component
                if offset == component.items.count {
                    component.items.append(newComponent)
                // if the indicator is at the beginning of component
                } else if offset < 0 {
                    component.items.insert(newComponent, at: 0)
                } else if component.items[offset] is Empty  {
                    if component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm {
                        component.addValue(expression: newComponent, offset: offset)
                        newComponent.scale = adjustScale(expression: newComponent)
                        levelIn()
                    } else {
                        component.items[offset] = newComponent
                        
                    }
                } else {
                    guard (component is Fraction || component is Root || component is IndexAndExponent || component is Index || component is Logarithm) == false else { return }
                    component.items[offset].color = defaultColor
                    component.items.insert(newComponent, at: offset)
                }
                levelIn()
            } else if let text = expression as? Text {
                guard offset > 0 else { return }
                newComponent.parent = text.parent
                //newComponent.scale = adjustScale(expression: newComponent)
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

        func delete() {
            if let component = expression as? Component {
                if component is Root || component is Fraction || component is IndexAndExponent || component is Index || component is Logarithm{
                    component.delete(offset: offset)
                    component.items[offset].color = selectedColor

                // if the indicator is at the end of the component
                } else if offset == component.items.count {
                    // if the last item is text delete each character separatly
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
                // the indicator is somwhere in the middle
                } else if offset >= 0 {
                    // if we have an component with one elementt that is Empty expression go level out
                    if component.items.count == 1, component.items[0] is Empty {
                        levelOut()
                    } else {
                        component.items.remove(at: offset)
                        checkIfTwoExpresionsAreTheSameType(offset: offset)
                        back()
                    }
                }
                // after the deletion check if component is empty
                if component.items.isEmpty {
                    // if we have deleted all items in component and the component has brackets it should append empty expression
                    if  component.showBrackets == true {
                        component.items.append({
                            let empty = Empty()
                            empty.color = selectedColor
                            empty.parent = component
                            return empty
                            }())
                        offset = 0
                    // if the component does not have brackets (components in fraction)
                    } else if component.parent != nil {
                        levelOut()
                        delete()
                    // the only component that does not have a parent is top level component - after the deletion of all items the offset should be set at 0
                    } else {
                        offset = 0
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
        
        func adjustScale(expression: Expression) -> CGFloat  {
            guard let parent = expression.parent else { return 1 }
            guard let parentOfParet = parent.parent else { return parent.scale }
            if expression is Fraction {
                if parentOfParet is Fraction {
                    return parentOfParet.scale * 0.8
                } else if let parentOfparentOfParet = parentOfParet.parent as? Fraction, (parent.showBrackets == true /*|| parent is Root*/) {
                    return parentOfparentOfParet.scale * 0.8
                } else if let root = parentOfParet as? Root, root.parent?.parent is Fraction, parent === root.radicand {
                    return root.scale * 0.8
                } else { return parent.scale }
            }  else { return parent.scale }
        }
    }
}

