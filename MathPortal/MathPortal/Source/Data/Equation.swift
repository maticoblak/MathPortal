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
    
    enum ExpressionType {
        case text
        case mathOperator
        case brackets
        case component
        case fraction
        case root
        case index
        case exponent
        case indexAndExponent
        case logarithm
        case naturalLog
        case empty
        case other
        case sin
        case cos
        case tan
        case cot
        case integral
        
        // For converting to JSON
        var string: String {
            switch self {
            case .text: return "text"
            case .mathOperator: return "operator"
            case .brackets: return "brackets"
            case .component: return "component"
            case .fraction: return "fraction"
            case .root: return "root"
            case .index: return "index"
            case .exponent: return "exponent"
            case .indexAndExponent: return "indexAndExponent"
            case .logarithm: return "logarithm"
            case .empty: return "empty"
            case .other: return "other"
            case .naturalLog: return "naturalLog"
            case .sin: return "sin"
            case .cos: return "cos"
            case .tan: return "tan"
            case .cot: return "cot"
            case .integral: return "integral"
            }
        }
        
        // For creating view
        var symbol: String? {
            switch self {
            case .logarithm: return "log"
            case .naturalLog: return "ln"
            case .sin: return "sin"
            case .cos: return "cos"
            case .tan: return "tan"
            case .cot: return "cot"
            default: return nil
            }
        }
    }
    
    static let selectedColor = Color.orange
    static let defaultColor = UIColor.clear

    var expression: Component = Component()
    
    func computeResult() -> Double? {
        return expression.computeResult()
    }
    
    lazy private var currentIndicator: Indicator = {
        return Indicator(expression: expression)
    }()
    
    convenience init(expression: Expression ) {
        self.init()
        guard let expression = expression as? Component else { return }
        self.expression = expression
    }
    
    func handleMathKeyboardButtonsPressed(button: MathSymbol.SymbolType) {
        switch button {
        case .integer(let value):
            currentIndicator.addString(String(value))
        case .letter(let letter):
            currentIndicator.addString(letter)
        case .comma:
            currentIndicator.addString(",")
        case .plus:
            currentIndicator.addOperator(.plus)
        case .minus:
            currentIndicator.addOperator(.minus)
        case .multiplication:
            currentIndicator.addOperator(.multiplication)
        case .division:
            currentIndicator.addOperator(.division)
        case .equal:
            currentIndicator.addOperator(.equal)
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
        case .indicator, .space, .enter:
            // TODO: add actions for those
            break
        case .fraction:
            currentIndicator.addComponent(Fraction(), brackets: false)
            break
        case .root:
            currentIndicator.addComponent(Root(), brackets: false)
            break
        case .indexAndExponent:
            currentIndicator.addComponent(IndexAndExponent(), brackets: false)
            break
        case .exponent:
            currentIndicator.addComponent(Exponent(), brackets: false)
        case .index:
            currentIndicator.addComponent(Index(), brackets: false)
            break
        case .logarithm:
            currentIndicator.addComponent(Logarithm(), brackets: false)
            break
        case .greekLetter(let letter):
            currentIndicator.addString(letter)
            break
        case .percent:
            currentIndicator.addString("%")
        case .sin:
            currentIndicator.addComponent(TrigonometricFunc(type: .sin), brackets: false)
            break
        case .cos:
            currentIndicator.addComponent(TrigonometricFunc(type: .cos), brackets: false)
            break
        case .tan:
            currentIndicator.addComponent(TrigonometricFunc(type: .tan), brackets: false)
            break
        case .cot:
            currentIndicator.addComponent(TrigonometricFunc(type: .cot), brackets: false)
            break
        case .naturalLog:
            break
        case .limit:
            break
        case .integral:
            currentIndicator.addComponent(Integral(), brackets: false)
            break
        case .lessThan:
            currentIndicator.addString("<")
        case .greaterThan:
            currentIndicator.addString(">")
        case .faculty:
            currentIndicator.addString("!")
        case .degree:
            break
        case .absoluteValue:
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
        var scale: CGFloat = 1.0 {
            didSet {
                guard scale < 0.5 else { return }
                scale = 0.5
            }
        }
        func computeResult() -> Double? { return nil }
        
        func generateView() -> EquationView { return .Nil }
    }
    
    func viewBounds() -> (width: CGFloat?, height: CGFloat?) {
        let view = self.expression.generateView().view?.frame
        return (view?.width, view?.height)
    }
    
    // MARK: - Operator
    class Operator: Expression {
        enum OperatorType: CaseIterable {
            case plus
            case minus
            case multiplication
            case division
            case equal
            
            var string: String {
                switch self {
                case .minus: return "-"
                case .plus: return "+"
                case .multiplication: return "·"
                case .division: return ":"
                case .equal: return "="
    
                }
            }
            static func fromParseString(_ string: String) -> OperatorType { return OperatorType.allCases.first(where: { $0.string == string }) ?? .plus }
        }

        var type: OperatorType
        
        init(_ type: OperatorType) {
            self.type = type
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateOperator(type, backgroundColor: color, scale: scale)
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
            return EquationView.generateText(value: value, textRange: textRange, backgroundColor: color, scale: scale)
        }
    }
    // MARK: - Fraction
    class Fraction: Component {
        // TODO: Maybe it is better to have empty in the component as all the other Expressions - reduces the if statements in the forward, back, delete,... since now we have to check if the component is empty and if it is, is it also a fraction or a normal component. If Empty expression would be in component that case would never happen
        override var scale: CGFloat  {
            didSet {
                refreshScalesInComponent()
            }
        }
        
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return}
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
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset else { return }
            guard let expression = expression else { return }
            if offset == 0  {
                self.enumerator = expression
            } else if offset == 1 {
                self.denomenator = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateFraction(items.map { $0.generateView() }, selectedColor: color, scale: scale, brackets: showBrackets)
        }

        // NOTE: When adding the enumerator and the denominator the order of setting them has to be correct since we are adding components in array at the specific index
        init(enumerator: Expression?, denomenator: Expression?) {
            super.init()
            self.enumerator = enumerator ?? Empty()
            self.denomenator = denomenator ?? Empty()
        }
        override convenience init() {
            self.init(enumerator: Empty(), denomenator: Empty())
        }
    }
    
    // MARK: - Root
    
    class Root: Component {
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return}
            if rootIndex is Empty {
                rootIndex.scale = self.scale / 2
            }
            if radicand is Empty {
                radicand.scale = self.scale
            }
        }
        var rootIndex: Expression {
            get { return items[0]}
            set {
                newValue.parent = self
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale / 2 /* newValue.scale*/
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale / 2
                    newValue.parent = newComponent
                    items[0] = newComponent
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        var radicand: Expression {
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
        init(index: Expression?, radicand: Expression?) {
            super.init()
            self.rootIndex = index ?? Empty()
            self.radicand = radicand ?? Empty()
        }
        override func addValue(expression: Expression?, offset: Int?) {
            guard let offset = offset else { return }
            guard let expression = expression else { return }
            if offset == 0  {
                self.rootIndex = expression
            } else if offset == 1 {
                self.radicand = expression
            }
        }
        override convenience init() {
            self.init(index: Empty(), radicand: Empty())
        }
        override func generateView() -> EquationView {
            return EquationView.generateRoot(items.map { $0.generateView() }, selectedColor: color, scale: scale, brackets: showBrackets)
        }
    }
    
    // MARK: - Exponent
    class Exponent: Index {
        override func generateView() -> EquationView {
            return EquationView.generateExponentAndIndex(items.map { $0.generateView()}, type: .exponent, selectedColor: color, scale: scale, brackets: showBrackets)
        }
    }
    
    // MARK: - Index
    
    class Index: Component {
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return}
            if base is Empty {
                base.scale = self.scale
            }
            if index is Empty {
                index.scale = self.scale * 0.7
            }
        }
        
        var base: Expression {
            get { return items[0]}
            set {
                newValue.parent = self
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component {
                        newValue.showBrackets = true
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newComponent.scale = self.scale
                        newValue.parent = newComponent
                        items[0] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }}
        }
        
        var index: Expression {
            get { return items[1]}
            set {
                newValue.parent = self
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[1] = newComponent
                } else {
                    let newComponent = Component(items: [items[2], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }}
        }
        
        init(base: Expression, exponent: Expression ) {
            super.init()
            self.base = base
            self.index = exponent
        }
        override convenience init() {
            self.init(base: Empty(), exponent: Empty())
        }
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset <= 2 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                base = expression
            } else if offset == 1 {
                index = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateExponentAndIndex(items.map { $0.generateView()}, type: .index, selectedColor: color, scale: scale, brackets: showBrackets)
        }
    }
    
    // MARK: - Exponent & index
    
    class IndexAndExponent: Component {
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return }
            if base is Empty {
                base.scale = self.scale
            }
            if index is Empty {
                index.scale = self.scale * 0.7
            }
            if exponent is Empty {
                exponent.scale = self.scale * 0.7
            }
        }
        
        var base: Expression {
            get { return items[0]}
            set {
                newValue.parent = self
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component, newValue.showBrackets == true {
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newComponent.scale = self.scale
                        newValue.parent = newComponent
                        if let newValue = newValue as? Component, newValue.showBrackets == false {
                            newComponent.showBrackets = true
                        }
                        items[0] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }}
        }
        var index: Expression {
            get { return items[1]}
            set {
                newValue.parent = self
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[1] = newComponent
                } else {
                    let newComponent = Component(items: [items[1], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }}
        }
        
        var exponent: Expression {
            get { return items[2]}
            set {
                newValue.parent = self
                if items.count < 3 {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[2] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[2] = newComponent
                } else {
                    let newComponent = Component(items: [items[2], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[2] = newComponent
                }}
        }
        
        init(base: Expression, index: Expression, exponent: Expression ) {
            super.init()
            self.base = base
            self.index = index
            self.exponent = exponent
        }
        override convenience init() {
            self.init(base: Empty(), index: Empty(), exponent: Empty())
        }
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset <= 2 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                base = expression
            } else if offset == 1 {
                index = expression
            } else if offset == 2 {
                exponent = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateExponentAndIndex(items.map { $0.generateView()}, type: .indexAndExponent, selectedColor: color, scale: scale, brackets: showBrackets)
        }
    }
    // MARK: - Logarithm
    
    class Logarithm: Component {
        
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return }
            if base is Empty {
                base.scale = self.scale
            }
            if index is Empty {
                index.scale = self.scale * 0.7
            }
        }
        
        var base: Expression {
            get { return items[0]}
            set {
                newValue.parent = self
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component {
                        newValue.showBrackets = true
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newComponent.scale = self.scale
                        newValue.parent = newComponent
                        items[0] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }}
        }
        
        var index: Expression {
            get { return items[1]}
            set {
                newValue.parent = self
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[1] = newComponent
                } else {
                    let newComponent = Component(items: [items[2], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }}
        }
        
        init(base: Expression, exponent: Expression ) {
            super.init()
            self.base = base
            self.index = exponent
            
        }
        override convenience init() {
            self.init(base: Empty(), exponent: Empty())
        }
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset <= 2 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                base = expression
            } else if offset == 1 {
                index = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateFunction(items.map { $0.generateView()}, selectedColor: color, scale: scale, type: .logarithm, brackets: showBrackets)
        }
    }
    
    // MARK: - Trigonometric func
    class TrigonometricFunc: Component {
        enum FunctionType: String {
            case sin, cos, tan, cot
            
            // TODO: Stupid solution for noe....
            var expressionType: Equation.ExpressionType {
                switch self {
                case .sin: return Equation.ExpressionType.sin
                case .cos: return Equation.ExpressionType.cos
                case .tan: return Equation.ExpressionType.tan
                case .cot: return Equation.ExpressionType.cot
                }
            }
        }
        
        var functionType: FunctionType = .sin
        
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        // TODO: Check/set scale in scale's didSet
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return}
            if angle is Empty {
                angle.scale = self.scale
            }
        }
        
        var angle: Expression {
            get { return items[0]}
            set {
                newValue.parent = self
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component {
                        newValue.showBrackets = true
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newComponent.scale = self.scale
                        newValue.parent = newComponent
                        items[0] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.showBrackets = true
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }
                
            }
        }
        
        // TODO: Figure out a better way to have index in a component in general
//        var index: Expression {
//            get { return items[1]}
//            set {
//                newValue.parent = self
//                if items.isEmpty {
//                    guard newValue is Empty else { return }
//                    newValue.scale = self.scale * 0.7
//                    items.append(newValue)
//                } else if items[1] is Empty {
//                    let newComponent = Component(items: [newValue])
//                    newComponent.parent = self
//                    newComponent.scale = self.scale * 0.7
//                    newValue.parent = newComponent
//                    items[1] = newComponent
//                } else {
//                    let newComponent = Component(items: [items[2], newValue])
//                    newComponent.parent = self
//                    newValue.parent = newComponent
//                    items[1] = newComponent
//                }}
//        }
        
        init(type: FunctionType, angle: Expression, index: Expression? ) {
            super.init()
            self.angle = angle
            functionType = type
            
        }
        
        convenience init(type: FunctionType, items: [Expression]? = nil) {
            self.init(type: type, angle: Empty(), index: nil)
            if let items = items {
                items.forEach { $0.parent = self; $0.scale = self.scale }
                self.items = items
            }
        }
        
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset <= 1 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                angle = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateFunction(items.map { $0.generateView()}, selectedColor: color, scale: scale, type: functionType.expressionType, brackets: showBrackets)
        }
    }
    
    // MARK: - Integral
    
    class Integral: Component {
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        override func refreshScalesInComponent() {
            guard scale >= 0.5 else { scale = 0.5; return}
            if base is Empty {
                base.scale = self.scale
            }
        }
        var base: Expression {
            get { return items[0]}
            set {
                newValue.parent = self
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.scale = self.scale
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale
                    newValue.parent = newComponent
                    items[0] = newComponent
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        
        init(base: Expression?) {
            super.init()
            self.base = base ?? Empty()
        }
       
        override convenience init() {
            self.init(base: Empty())
        }
        override func generateView() -> EquationView {
            return EquationView.generateIntegral(items.map { $0.generateView() }, selectedColor: color, scale: scale, brackets: showBrackets)
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
        var items: [Expression] = [Expression]()
        override var scale: CGFloat {
            didSet {
                refreshScalesInComponent()
            }
        }
        
        convenience init(items: [Expression]) {
            self.init()
            items.forEach { $0.parent = self; $0.scale = self.scale }
            self.items = items
        }
        
        func refreshScalesInComponent() {
            if items.count == 1 {
                items[0].scale = self.scale
            }
        }
        
        func addValue(expression: Expression?, offset: Int?) { }
        func delete(offset: Int) {
            guard offset < items.count else { return }
            guard self.items[offset] is Empty == false else { return }
            let empty = Empty()
            empty.parent = self
            empty.scale = items[offset].scale
            self.items[offset] = empty
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
                        case .multiplication: return value
                        case .division: return value
                        case .equal: return value
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
            if items.isEmpty {
                return .Nil
            } else {
                return EquationView.linearlyLayoutViews(items.map { $0.generateView() }, type: .component, selectedColor: color, brackets: showBrackets, scale: scale)
            }
        }
    }
}

extension Equation {
    /* NOTE:
     - Exponent should always be checked before Index since exponent is subclass of Index
     - Fraction, Root, Index, Exponent, IndexAndExponent, Logarithm should alyas be checked before Component, since they are subclasses of component
     */
    static func equationToJson(equation: Equation.Expression) -> [String: Any] {
        if let fraction = equation as? Equation.Fraction {
            return [Equation.ExpressionType.fraction.string : fraction.items.map { equationToJson(equation: $0) }]
        } else if let root = equation as? Equation.Root {
            return [Equation.ExpressionType.root.string : root.items.map { equationToJson(equation: $0) }]
        } else if let exponent = equation as? Equation.Exponent {
            return [Equation.ExpressionType.exponent.string : exponent.items.map { equationToJson(equation: $0) }]
        } else if let index = equation as? Equation.Index {
            return [Equation.ExpressionType.index.string: index.items.map { equationToJson(equation: $0) }]
        } else if let indexAndExponent = equation as? Equation.IndexAndExponent {
            return [Equation.ExpressionType.indexAndExponent.string : indexAndExponent.items.map { equationToJson(equation: $0) }]
        } else if let logarithm = equation as? Equation.Logarithm {
            return [Equation.ExpressionType.logarithm.string : logarithm.items.map { equationToJson(equation: $0) }]
        } else if let trigonometricFunc = equation as? Equation.TrigonometricFunc {
            let key: String
            switch trigonometricFunc.functionType {
            case .sin:
                key = Equation.ExpressionType.sin.string
            case .cos:
                key = Equation.ExpressionType.cos.string
            case .tan:
                key = Equation.ExpressionType.tan.string
            case .cot:
                key = Equation.ExpressionType.cot.string
            }
            return [key : trigonometricFunc.items.map { equationToJson(equation: $0) }]
        } else if let mathOperator = equation as? Equation.Operator {
            return [Equation.ExpressionType.mathOperator.string: mathOperator.type.string ]
        } else if let text = equation as? Equation.Text {
            return [Equation.ExpressionType.text.string: text.value]
        } else if equation is Equation.Empty {
            return [Equation.ExpressionType.empty.string : "empty"]
        } else if let component =  equation as? Equation.Component {
            if component.showBrackets {
                return [Equation.ExpressionType.brackets.string : component.items.map { equationToJson(equation: $0) }]
            } else {
                return [Equation.ExpressionType.component.string : component.items.map { equationToJson(equation: $0) }]
            }
        } else {
            return [Equation.ExpressionType.other.string : "expression"]
        }
    }
    
    static func JSONToEquation(json: [String : Any]?) -> Equation.Expression {
        guard let json = json else { return Equation.Expression() }
        if let text = json[Equation.ExpressionType.text.string] as? String {
            return Equation.Text(text)
        } else if let mathOperator = json[Equation.ExpressionType.mathOperator.string] as? String {
            return Equation.Operator(Equation.Operator.OperatorType.fromParseString(mathOperator))
        } else if let _ = json[Equation.ExpressionType.empty.string] as? String {
            return Equation.Empty()
        } else if let fraction = json[Equation.ExpressionType.fraction.string] as? [[String:Any]] {
            guard fraction.count == 2 else { return Equation.Fraction() }
            return Equation.Fraction(items: fraction.map { JSONToEquation(json: $0)})
        } else if let root = json[Equation.ExpressionType.root.string] as? [[String : Any]] {
            guard root.count == 2 else { return Equation.Root() }
            return Equation.Root(items: root.map { JSONToEquation(json: $0)})
        } else if let exponent = json[Equation.ExpressionType.exponent.string] as? [[String : Any]] {
            guard exponent.count == 2 else { return Equation.Exponent() }
            return Equation.Exponent(items: exponent.map { JSONToEquation(json: $0)})
        } else if let index = json[Equation.ExpressionType.index.string] as? [[String : Any]] {
            guard index.count == 2 else { return Equation.Index() }
            return Equation.Index(items: index.map { JSONToEquation(json: $0)})
        } else if let indexAndExponent = json[Equation.ExpressionType.indexAndExponent.string] as? [[String : Any]] {
            guard indexAndExponent.count == 3 else { return Equation.IndexAndExponent() }
            return Equation.IndexAndExponent(items: indexAndExponent.map { JSONToEquation(json: $0)})
        } else if let logarithm = json[Equation.ExpressionType.logarithm.string] as? [[String : Any]] {
            guard logarithm.count == 2 else { return Equation.Logarithm() }
            return Equation.Logarithm(items: logarithm.map { JSONToEquation(json: $0)})
        } else if let sin = json[Equation.ExpressionType.sin.string] as? [[String : Any]] {
            return Equation.TrigonometricFunc(type: .sin, items: sin.map { JSONToEquation(json: $0)})
        } else if let cos = json[Equation.ExpressionType.cos.string] as? [[String : Any]] {
            return Equation.TrigonometricFunc(type: .cos, items: cos.map { JSONToEquation(json: $0)})
        } else if let tan = json[Equation.ExpressionType.tan.string] as? [[String : Any]] {
            return Equation.TrigonometricFunc(type: .tan, items: tan.map { JSONToEquation(json: $0)})
        } else if let cot = json[Equation.ExpressionType.cot.string] as? [[String : Any]] {
            return Equation.TrigonometricFunc(type: .cot, items: cot.map { JSONToEquation(json: $0)})
        } else if let componentBrackets = json[Equation.ExpressionType.brackets.string] as? [[String : Any]] {
            let brackets = Equation.Component(items: componentBrackets.map { JSONToEquation(json: $0)})
            brackets.showBrackets = true
            return brackets
        } else if let component = json[Equation.ExpressionType.component.string] as? [[String : Any]] {
            return Equation.Component(items: component.map { JSONToEquation(json: $0) })
        } else {
            return Equation.Expression()
        }
    }
}
