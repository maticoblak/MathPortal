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
        case absoluteValue
        case component
        case fraction
        case root
        case index
        case exponent
        case indexAndExponent
        case logarithm
        case naturalLog
        case empty
        case sin
        case cos
        case tan
        case cot
        case integral
        case limit
        case horizontalSpace
        case sumSeries
        case productSeries
        
        case other // For views that make one of the above
        
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
            case .limit: return "limit"
            case .absoluteValue: return "absoluteValue"
            case .horizontalSpace: return "horizontalSpace"
            case .sumSeries: return "sumSeries"
            case .productSeries: return "productSeries"
            }
        }
        
        // For creating view
        var symbol: String? {
            switch self {
            case .logarithm: return "log"
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
    
    func viewBounds() -> (width: CGFloat?, height: CGFloat?) {
        let view = self.expression.generateView().view?.frame
        return (view?.width, view?.height)
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
            currentIndicator.addComponent(brackets: .normal)
        case .back:
            currentIndicator.back()
        case .delete:
            currentIndicator.delete()
        case .forward:
            currentIndicator.forward()
        case .levelIn:
            currentIndicator.levelIn()
        case .levelOut:
            currentIndicator.levelOut()
        case .indicator, .enter, .degree, .done:
            // TODO: add actions for those
            break
        case .space:
            currentIndicator.addSpace()
        case .fraction:
            currentIndicator.addComponent(Fraction())
        case .root:
            currentIndicator.addComponent(Root())
        case .indexAndExponent:
            currentIndicator.insertComponent(IndexAndExponent())
        case .exponent:
            currentIndicator.insertComponent(Exponent())
        case .index:
            currentIndicator.insertComponent(Index())
        case .logarithm:
            currentIndicator.addComponent(Logarithm())
        case .percent:
            currentIndicator.addString("%")
        case .sin:
            currentIndicator.addComponent(TrigonometricFunc(type: .sin))
        case .cos:
            currentIndicator.addComponent(TrigonometricFunc(type: .cos))
        case .tan:
            currentIndicator.addComponent(TrigonometricFunc(type: .tan))
        case .cot:
            currentIndicator.addComponent(TrigonometricFunc(type: .cot))
        case .limit:
            currentIndicator.addComponent(Limit())
        case .integral:
            currentIndicator.addComponent(Integral())
        case .sumSeries:
            currentIndicator.addComponent(Series(.sum))
        case .productSeries:
            currentIndicator.addComponent(Series(.product))
        case .lessThan:
            currentIndicator.addString("<")
        case .greaterThan:
            currentIndicator.addString(">")
        case .lessOrEqualThen:
            currentIndicator.addString("≤")
        case .greaterOrEqualThen:
            currentIndicator.addString("≥")
        case .notEqual:
            currentIndicator.addString("≠")
        case .faculty:
            currentIndicator.addString("!")
        case .infinity:
            currentIndicator.addString("∞")
        case .absoluteValue:
            currentIndicator.addComponent(brackets: .absolute)
        }
    }
}

// MARK: - Expressions

extension Equation {
    // MARK: - Expression
    class Expression {
        weak var parent: Component? {
            didSet {
                adjustScale()
            }
        }
        var color: UIColor = defaultColor
        /// Should not be overridden but n the case it is add the minimum scale 0.5
        var scale: CGFloat = 1.0 {
            didSet {
                guard scale < 0.5 else { return }
                scale = 0.5
            }
        }
        func computeResult() -> Double? { return nil }
        
        func generateView() -> EquationView { return .Nil }
        
        /// When parent is set or changed the scale should be updated
        func adjustScale() {
            scale = parent?.scale ?? 1
        }
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
        
        init(_ type: OperatorType, parent: Component?) {
            self.type = type
            super.init()
            self.parent = parent
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
        
        convenience init(_ value: String, parent: Component?) {
            self.init(value)
            self.parent = parent
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
        override func refreshScalesInComponent() {
            enumerator.scale = self.scale * 0.9
            denomenator.scale = self.scale * 0.9
        }
        
        private var enumerator: Expression {
            get { return items[0] }
            set {
                if items.isEmpty {
                    //new value has to be empty if we are creating new fraction
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    newValue.scale = self.scale * 0.9
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.9
                    newValue.parent = newComponent
                    items[0] = newComponent
                // Probably will need in the future or just a safety case
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.9
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        private var denomenator: Expression {
            get { return items[1] }
            set {
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    newValue.scale = self.scale * 0.9
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.9
                    newValue.parent = newComponent
                    items[1] = newComponent
                } else {
                    let newComponent = Component(items: [items[1], newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.9
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
        
        // NOTE: When adding the enumerator and the denominator the order of setting them has to be correct since we are adding components in array at the specific index
        init(enumerator: Expression?, denomenator: Expression?) {
            super.init()
            self.enumerator = enumerator ?? Empty()
            self.denomenator = denomenator ?? Empty()
        }
        /// Init with empty fields
        override convenience init() {
            self.init(enumerator: Empty(), denomenator: Empty())
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateFraction(items.map { $0.generateView() }, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    
    // MARK: - Root
    
    class Root: Component {

        override func refreshScalesInComponent() {
            rootIndex.scale = self.scale / 2
            radicand.scale = self.scale
        }
        
        private var rootIndex: Expression {
            get { return items[0]}
            set {
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    newValue.scale = self.scale / 2
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
                    newComponent.scale = self.scale / 2
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        
        private var radicand: Expression {
            get { return items[1] }
            set {
                
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
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
        
        /// Init with empty fields
        override convenience init() {
            self.init(index: Empty(), radicand: Empty())
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
        
        override func generateView() -> EquationView {
            return EquationView.generateRoot(items.map { $0.generateView() }, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    
    // MARK: - Exponent
    class Exponent: Index {
        override func generateView() -> EquationView {
            return EquationView.generateExponentAndIndex(items.map { $0.generateView()}, type: .exponent, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    
    // MARK: - Index
    class Index: Component {

        override func refreshScalesInComponent() {
            base.scale = self.scale
            index.scale = self.scale * 0.7
        }
        
        private var base: Expression {
            get { return items[0]}
            set {
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component, newValue.hasBrackets() == true {
                        newValue.parent = self
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newValue.parent = newComponent
                        if let newValue = newValue as? Component, newValue.hasBrackets() == false {
                            newComponent.brackets = .normal
                        }
                        items[0] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        
        private var index: Expression {
            get { return items[1]}
            set {
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
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
                    newComponent.scale = self.scale * 0.7
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
            return EquationView.generateExponentAndIndex(items.map { $0.generateView()}, type: .index, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    
    // MARK: - Exponent & index
    
    class IndexAndExponent: Component {

        override func refreshScalesInComponent() {
            base.scale = self.scale
            index.scale = self.scale * 0.7
            exponent.scale = self.scale * 0.7
        }
        
        private var base: Expression {
            get { return items[0]}
            set {
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component, newValue.hasBrackets() == true {
                        newValue.parent = self
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newValue.parent = newComponent
                        if let newValue = newValue as? Component, newValue.hasBrackets() == false {
                            newComponent.brackets = .normal
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
        
        private var index: Expression {
            get { return items[1]}
            set {
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
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
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[1] = newComponent
                }
            }
        }
        
       private  var exponent: Expression {
            get { return items[2]}
            set {
                if items.count < 3 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
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
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[2] = newComponent
                }
            }
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
            return EquationView.generateExponentAndIndex(items.map { $0.generateView()}, type: .indexAndExponent, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    // MARK: - Logarithm
    
    class Logarithm: Component {
        
        override func refreshScalesInComponent() {
            base.scale = self.scale
            index.scale = self.scale * 0.7
        }
        
        private var base: Expression {
            get { return items[1]}
            set {
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[1] is Empty {
                    if let newValue = newValue as? Component {
                        newValue.parent = self
                        if newValue.hasBrackets() == false {
                            newValue.brackets = .normal
                        }
                        items[1] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newValue.parent = newComponent
                        items[1] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[1], newValue])
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }
            }
        }
        
        private var index: Expression {
            get { return items[0]}
            set {
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[0] = newComponent
                } else {
                    let newComponent = Component(items: [items[0], newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        
        init(base: Expression, exponent: Expression ) {
            super.init()
            self.index = exponent
            self.base = base
        }
        override convenience init() {
            self.init(base: Empty(), exponent: Empty())
        }
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset <= 2 else { return }
            guard let expression = expression else { return }
            if offset == 1 {
                base = expression
            } else if offset == 0 {
                index = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateFunction(items.map { $0.generateView()}, selectedColor: color, scale: scale, type: .logarithm, brackets: brackets)
        }
    }
    
    // MARK: - Limit
    
    class Limit: Component {
        
        override func refreshScalesInComponent() {
            base.scale = self.scale
            variable.scale = self.scale * 0.7
            limitValue.scale = self.scale * 0.7
        }
        
        private var variable: Expression {
            get { return items[0]}
            set {
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[0] = newComponent
                } else {
                    let newComponent = Component(items: [items[0], newValue], brackets: .normal)
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[0] = newComponent
                }
            }
        }
        
        var limitValue: Expression {
            get { return items[1]}
            set {
                if items.count < 2 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    newValue.scale = self.scale * 0.7
                    items.append(newValue)
                } else if items[1] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[1] = newComponent
                } else {
                    let newComponent = Component(items: [items[1], newValue], brackets: .normal)
                    newComponent.parent = self
                    newComponent.scale = self.scale * 0.7
                    newValue.parent = newComponent
                    items[1] = newComponent
                }
            }
        }
        
        var base: Expression {
            get { return items[2]}
            set {
                
                if items.count < 3 {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[2] is Empty {
                    if let newValue = newValue as? Component {
                        newValue.parent = self
                        if newValue.hasBrackets() == false {
                            newValue.brackets = .normal
                        }
                        items[2] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newValue.parent = newComponent
                        items[2] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[2], newValue], brackets: .normal)
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[2] = newComponent
                }
            }
        }
        
        init(base: Expression, variable: Expression, limitValue: Expression) {
            super.init()
            self.variable = variable
            self.limitValue = limitValue
            self.base = base
        
        }
        
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset < 3 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                variable = expression
            } else if offset == 1 {
                limitValue = expression
            } else if offset == 2 {
                base = expression
            }
        }
        
        override convenience init() {
            self.init(base: Empty(), variable: Empty(), limitValue: Empty())
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateLimit(items.map { $0.generateView()}, selectedColor: color, scale: scale, brackets: brackets)
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
        
        var angle: Expression {
            get { return items[0]}
            set {
                
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[0] is Empty {
                    if let newValue = newValue as? Component {
                        newValue.parent = self
                        if newValue.hasBrackets() == false {
                            newValue.brackets = .normal
                        }
                        items[0] = newValue
                    } else {
                        let newComponent = Component(items: [newValue])
                        newComponent.parent = self
                        newValue.parent = newComponent
                        items[0] = newComponent
                    }
                } else {
                    let newComponent = Component(items: [items[0], newValue], brackets: .normal)
                    newComponent.parent = self
                    newValue.parent = newComponent
                    items[1] = newComponent
                }
                
            }
        }
        
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
            return EquationView.generateFunction(items.map { $0.generateView()}, selectedColor: color, scale: scale, type: functionType.expressionType, brackets: brackets)
        }
    }
    
    // MARK: - Integral
    
    class Integral: Component {
        
        var base: Expression {
            get { return items[0]}
            set {
                
                if items.isEmpty {
                    guard newValue is Empty else { return }
                    newValue.parent = self
                    items.append(newValue)
                } else if items[0] is Empty {
                    let newComponent = Component(items: [newValue])
                    newComponent.parent = self
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
       
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset < 1 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                base = expression
            }
        }
        
        override convenience init() {
            self.init(base: Empty())
        }
        override func generateView() -> EquationView {
            return EquationView.generateIntegral(items.map { $0.generateView() }, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    
    //MARK: - Series
    
    class Series: Component {
        
        enum SeriesType {
            case product
            case sum
            
            var equationType: Equation.ExpressionType {
                switch self {
                case .product: return .productSeries
                case .sum: return .sumSeries
                }
            }
        }
        
        var type: SeriesType = .sum
        
        override func refreshScalesInComponent() {
             base.scale = self.scale
             minBound.scale = self.scale * 0.7
             maxBound.scale = self.scale * 0.7
         }
         
         private var base: Expression {
             get { return items[2]}
             set {
                 if items.count < 3 {
                     guard newValue is Empty else { return }
                     newValue.parent = self
                     items.append(newValue)
                 } else if items[2] is Empty {
                     if let newValue = newValue as? Component, newValue.hasBrackets() == true {
                         newValue.parent = self
                         items[2] = newValue
                     } else {
                         let newComponent = Component(items: [newValue])
                         newComponent.parent = self
                         newValue.parent = newComponent
                         if let newValue = newValue as? Component, newValue.hasBrackets() == false {
                             newComponent.brackets = .normal
                         }
                         items[2] = newComponent
                     }
                 } else {
                     let newComponent = Component(items: [items[2], newValue])
                     newComponent.parent = self
                     newValue.parent = newComponent
                     items[2] = newComponent
                 }}
         }
         
         private var maxBound: Expression {
             get { return items[1]}
             set {
                 if items.count < 2 {
                     guard newValue is Empty else { return }
                     newValue.parent = self
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
                     newComponent.scale = self.scale * 0.7
                     newValue.parent = newComponent
                     items[1] = newComponent
                 }
             }
         }
         
        private  var minBound: Expression {
             get { return items[0]}
             set {
                 if items.isEmpty {
                     guard newValue is Empty else { return }
                     newValue.parent = self
                     newValue.scale = self.scale * 0.7
                     items.append(newValue)
                 } else if items[0] is Empty {
                     let newComponent = Component(items: [newValue])
                     newComponent.parent = self
                     newComponent.scale = self.scale * 0.7
                     newValue.parent = newComponent
                     items[0] = newComponent
                 } else {
                     let newComponent = Component(items: [items[0], newValue])
                     newComponent.parent = self
                     newComponent.scale = self.scale * 0.7
                     newValue.parent = newComponent
                     items[0] = newComponent
                 }
             }
         }
         
        init(_ type: SeriesType, base: Expression, minBound: Expression, maxBound: Expression ) {
            super.init()
            self.type = type
            self.minBound = minBound
            self.maxBound = maxBound
            self.base = base
        }
        
        convenience init(_ type: SeriesType) {
             self.init(type, base: Empty(), minBound: Empty(), maxBound: Empty())
        }
        
        convenience init(_ type: SeriesType, items: [Expression], brackets: BracketsType = .none) {
            self.init(type)
            guard items.count == 3 else { return }
            items.forEach { $0.parent = self; $0.scale = self.scale }
            self.items = items
            self.brackets = brackets
        }
        
        override func addValue(expression: Equation.Expression?, offset: Int?) {
            guard let offset = offset, offset <= 2 else { return }
            guard let expression = expression else { return }
            if offset == 0 {
                minBound = expression
            } else if offset == 1 {
                maxBound = expression
            } else if offset == 2 {
                base = expression
            }
        }
        override func generateView() -> EquationView {
            return EquationView.generateSeries(items.map { $0.generateView()}, type: type, selectedColor: color, scale: scale, brackets: brackets)
        }
    }
    
    // MARK: - Empty
    class Empty: Expression {
        
        /// Needs scale because of deletion, also scale has to be set after parnt is set because of did set
        convenience init(scale: CGFloat? = nil, parent: Component, selectedColor: UIColor? = nil) {
            self.init()
            self.parent = parent
            if let scale = scale { self.scale = scale }
            if let selectedColor = selectedColor { self.color = selectedColor }
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateEmpty(backgroundColor: color, scale: scale)
        }
    }
    
    // MARK: - Space
    
    class Space: Expression {
        
        enum Direction {
            case vertical
            case horizontal
        }
        
        var direction: Direction = .vertical
        
        convenience init(direction: Direction) {
            self.init()
            self.direction = direction
        }
        
        override func generateView() -> EquationView {
            return EquationView.generateSpace(in: parent, scale: scale, selectedColor: color)
        }
    }
    
    // MARK: - Component
    class Component: Expression {
        
        enum BracketsType {
            case none
            case normal
            case absolute
        }

        func hasBrackets() -> Bool {
            switch brackets {
            case .none: return false
            case .absolute, .normal: return true
            }
        }
        
        var brackets: BracketsType = .none
      
        var items: [Expression] = [Expression]()
        
        override var scale: CGFloat {
            didSet {
                // NOTE: Just for safety - Should never happen since all other exponents have guard set for 0.5 and Component is never the las one in equation
                guard scale >= 0.5 else {
                    scale = 0.5
                    return
                }
                refreshScalesInComponent()
            }
        }
        
        convenience init(items: [Expression], brackets: BracketsType = .none) {
            self.init()
            items.forEach { $0.parent = self; $0.scale = self.scale }
            self.items = items
            self.brackets = brackets
        }
        
        /// Override only if the scale of items in component is not equal to their parent. If not overridden the scale of items will be the same as their parent
        func refreshScalesInComponent() {
            items.forEach { $0.scale = self.scale }
        }
        
        func addValue(expression: Expression?, offset: Int?) {
            guard let offset = offset, offset < items.count else { return }
            guard let expression = expression else { return }
            items[offset] = expression
        }
        func delete(offset: Int) {
            guard offset < items.count else { return }
            guard self.items[offset] is Empty == false else { return }
            let empty = Empty(scale: items[offset].scale, parent: self)
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
                return EquationView.linearlyLayoutViews(items.map { $0.generateView() }, type: .component, selectedColor: color, brackets: brackets, scale: scale)
            }
        }
    }
}

extension Equation {
    /* NOTE:
     - Exponent should always be checked before Index since exponent is subclass of Index
     - Fraction, Root, Index, Exponent, IndexAndExponent, Logarithm, Integral, TrignometricFunc should always be checked before Component, since they are subclasses of component
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
        } else if let series = equation as? Equation.Series {
            switch series.type {
            case .product:
                return [Equation.ExpressionType.productSeries.string : series.items.map { equationToJson(equation: $0) }]
            case .sum:
                return [Equation.ExpressionType.sumSeries.string : series.items.map { equationToJson(equation: $0) }]
            }
        } else if let limit = equation as? Equation.Limit {
            return [Equation.ExpressionType.limit.string : limit.items.map { equationToJson(equation: $0) }]
        } else if let integral = equation as? Equation.Integral {
            return [Equation.ExpressionType.integral.string : integral.items.map { equationToJson(equation: $0) }]
        } else if let mathOperator = equation as? Equation.Operator {
            return [Equation.ExpressionType.mathOperator.string: mathOperator.type.string ]
        } else if let text = equation as? Equation.Text {
            return [Equation.ExpressionType.text.string: text.value]
        } else if let _ = equation as? Space {
            return [Equation.ExpressionType.horizontalSpace.string: "hSpace"]
        } else if equation is Equation.Empty {
            return [Equation.ExpressionType.empty.string : "empty"]
        } else if let component =  equation as? Equation.Component {
            switch component.brackets {
            case .none:
                return [Equation.ExpressionType.component.string : component.items.map { equationToJson(equation: $0) }]
            case .normal:
                return [Equation.ExpressionType.brackets.string : component.items.map { equationToJson(equation: $0) }]
            case .absolute:
                return [Equation.ExpressionType.absoluteValue.string : component.items.map { equationToJson(equation: $0) }]
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
            return Equation.Operator(Equation.Operator.OperatorType.fromParseString(mathOperator), parent: nil)
        } else if let _ = json[Equation.ExpressionType.empty.string] as? String {
            return Equation.Empty()
        } else if let _ = json[Equation.ExpressionType.horizontalSpace.string] as? String {
            return Equation.Space(direction: .horizontal)
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
        } else if let sum = json[Equation.ExpressionType.sumSeries.string] as? [[String : Any]] {
            return Equation.Series(.sum, items: sum.map { JSONToEquation(json: $0)})
        } else if let product = json[Equation.ExpressionType.productSeries.string] as? [[String : Any]] {
            return Equation.Series(.product, items: product.map { JSONToEquation(json: $0)})
        } else if let limit = json[Equation.ExpressionType.limit.string] as? [[String : Any]] {
            return Equation.Limit(items: limit.map { JSONToEquation(json: $0) })
        } else if let integral = json[Equation.ExpressionType.integral.string] as? [[String : Any]] {
            guard integral.count == 1 else { return Equation.Integral() }
            return Equation.Integral(items: integral.map { JSONToEquation(json: $0)})
        } else if let componentBrackets = json[Equation.ExpressionType.brackets.string] as? [[String : Any]] {
            let brackets = Equation.Component(items: componentBrackets.map { JSONToEquation(json: $0)}, brackets: .normal)
            return brackets
        } else if let absoluteValue = json[Equation.ExpressionType.absoluteValue.string] as? [[String : Any]] {
            let component = Equation.Component(items: absoluteValue.map { JSONToEquation(json: $0)}, brackets: .absolute)
            return component
        } else if let component = json[Equation.ExpressionType.component.string] as? [[String : Any]] {
            return Equation.Component(items: component.map { JSONToEquation(json: $0) }, brackets:  .none)
        } else {
            return Equation.Expression()
        }
    }
}
