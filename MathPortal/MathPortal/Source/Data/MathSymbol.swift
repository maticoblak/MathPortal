//
//  KeyboardKeys.swift
//  MathPortal
//
//  Created by Petra Čačkov on 21/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class MathSymbol {
    
    let keyName: SymbolType
    
    init(key: SymbolType) {
        self.keyName = key
    }
}
extension MathSymbol {
    enum SymbolType {
        
        case integer(value: Int)
        case letter(value: String)
        
        case back
        case forward
        case delete
        case indicator
        case done
        case levelOut
        case levelIn
        case space
        case enter(type: Equation.Space.Direction = .newLine)
        
        case plus
        case minus
        case equal
        case comma
        case multiplication
        case division
        
        case brackets
        case fraction
        case root
        case exponent
        case percent
        
        case sin
        case cos
        case tan
        case cot
        case logarithm
        case indexAndExponent
        case index
        case lessThan
        case greaterThan
        case greaterOrEqualThen
        case lessOrEqualThen
        case notEqual
        case faculty
        case integral
        case limit
        case infinity
        case absoluteValue
        case sumSeries
        case productSeries
        
        case degree
        
        static var integers: [SymbolType] = Array(0...9).map { .integer(value: $0) }
        static var letters: [SymbolType] = Array("qwertyuiopasdfghjklzxcvbnm").map { .letter(value: String($0)) }
        static var lettersUppercase: [SymbolType] = Array("qwertyuiopasdfghjklzxcvbnm").map { .letter(value: String($0).uppercased()) }
        static var greekLetters: [SymbolType] = Array("αβγδεζηθικλμνξοπρστυφχψω").map { .letter(value: String($0)) }
        static var greekLettersUppercase: [SymbolType] = Array("ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ").map { .letter(value: String($0)) }
        
        var doubleTap: SymbolType {
            switch self {
            case .enter: return .enter(type: .vertical)
            default: return self
            }
        }
        
        var componentView: UIView? {
            switch self {
            case .fraction:
                guard let fraction: UIView = EquationView.generateFraction([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.9), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.9)], color: Color.darkBlue).view else { return EquationView.Nil.view}
                return fraction
            case .brackets:
                guard let brackets: UIView = EquationView.linearlyLayoutViews([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], type: .brackets, brackets: .normal, color: Color.darkBlue, scale: 1).view else { return EquationView.Nil.view }
                return brackets
            case .root:
                guard let root: UIView = EquationView.generateRoot([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.5), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue).view else { return EquationView.Nil.view}
                return root
            case .exponent:
                guard let exponent: UIView = EquationView.generateExponentAndIndex([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7)], type: .exponent, color: Color.darkBlue).view else { return EquationView.Nil.view }
                return exponent
            case .index:
                guard let index: UIView = EquationView.generateExponentAndIndex([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7) ], type: .index, color: Color.darkBlue).view else { return EquationView.Nil.view }
                return index
            case .indexAndExponent:
                guard let indexAndExponent: UIView = EquationView.generateExponentAndIndex([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7) , EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7) ], type: .indexAndExponent, color: Color.darkBlue).view else { return EquationView.Nil.view }
                return indexAndExponent
            case .logarithm:
                guard let log: UIView = EquationView.generateFunction([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue, type: .logarithm).view else { return EquationView.Nil.view}
                return log
            case .plus:
                guard let plus: UIView = EquationView.generateOperator( .plus, color: Color.darkBlue).view else { return EquationView.Nil.view}
                return plus
            case .minus:
                guard let minus: UIView = EquationView.generateOperator( .minus, color: Color.darkBlue).view else { return EquationView.Nil.view}
                return minus
            case .back:
                guard let back: UIView = EquationView.generateText(value: "←", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return back
            case .forward:
                guard let forward: UIView = EquationView.generateText(value: "→", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return forward
            case .delete:
                guard let delete: UIView = EquationView.generateText(value: "Delete", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return delete
            case .done:
                guard let done: UIView = EquationView.generateText(value: "Done", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return done
            case .integer(let value):
                guard let integer: UIView = EquationView.generateText(value: String(value), color: Color.darkBlue).view else { return EquationView.Nil.view }
                return integer
            case .levelIn:
                guard let levelIn: UIView = EquationView.generateText(value: "↧", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return levelIn
            case .levelOut:
                guard let levelOut: UIView = EquationView.generateText(value: "↥", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return levelOut
            case .indicator:
                break
            case .letter(let value):
                guard let letter: UIView = EquationView.generateText(value: value, color:  Color.darkBlue).view else { return EquationView.Nil.view }
                return letter
            case .multiplication:
                guard let multiplication: UIView = EquationView.generateText(value: "·", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return multiplication
            case .division:
                guard let division: UIView = EquationView.generateText(value: ":", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return division
            case .comma:
                guard let comma: UIView = EquationView.generateText(value: ",", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return comma
            case .equal:
                guard let equal: UIView = EquationView.generateText(value: "=", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return equal
            case .notEqual:
                guard let equal: UIView = EquationView.generateText(value: "≠", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return equal
            case .space:
                guard let space: UIView = EquationView.generateText(value: "space", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return space
            case .enter:
                guard let enter: UIView = EquationView.generateText(value: "enter", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return enter
            case .percent:
                guard let percent: UIView = EquationView.generateText(value: "%", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return percent
            case .sin:
                guard let sin: UIView = EquationView.generateFunction([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue, type: .sin).view else { return EquationView.Nil.view }
                return sin
            case .cos:
                guard let cos: UIView = EquationView.generateFunction([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue, type: .cos).view else { return EquationView.Nil.view }
                return cos
            case .tan:
                guard let tan: UIView = EquationView.generateFunction([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue, type: .tan).view else { return EquationView.Nil.view }
                return tan
            case .cot:
                guard let cot: UIView = EquationView.generateFunction([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue, type: .cot).view else { return EquationView.Nil.view }
                return cot
            case .limit:
                guard let limit: UIView = EquationView.generateLimit([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7),EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7),EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue).view else { return EquationView.Nil.view }
                return limit
            case .integral:
                guard let integral =  EquationView.generateIntegral([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], color: Color.darkBlue).view else { return  EquationView.Nil.view }
                return integral
            case .lessThan:
                guard let lessThan: UIView = EquationView.generateText(value: "<", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return lessThan
            case .greaterThan:
                guard let greaterThan: UIView = EquationView.generateText(value: ">", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return greaterThan
            case .lessOrEqualThen:
                guard let lessThan: UIView = EquationView.generateText(value: "≤", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return lessThan
            case .greaterOrEqualThen:
                guard let greaterThan: UIView = EquationView.generateText(value: "≥", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return greaterThan
            case .faculty:
                guard let faculty: UIView = EquationView.generateText(value: "!", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return faculty
            case .degree:
                return EquationView.Nil.view
            case .infinity:
                guard let infinity: UIView = EquationView.generateText(value: "∞", color: Color.darkBlue).view else { return EquationView.Nil.view }
                return infinity
            case .absoluteValue:
                guard let absoluteValue: UIView = EquationView.linearlyLayoutViews([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 1)], type: .brackets, brackets: .absolute, color: Color.darkBlue, scale: 1).view else { return EquationView.Nil.view }
                return absoluteValue
            case .sumSeries:
                guard let sumSeries: UIView = EquationView.generateSeries([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.4), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.4), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7)], type: .sum, color: Color.darkBlue, scale: 1).view else { return EquationView.Nil.view }
                return sumSeries
            case .productSeries:
                guard let sumSeries: UIView = EquationView.generateSeries([EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.4), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.4), EquationView.generateEmpty(squareColor: Color.darkBlue, scale: 0.7)], type: .product, color: Color.darkBlue, scale: 1).view else { return EquationView.Nil.view }
                return sumSeries
            }
            return nil
        }
        
    }
}
