//
//  KeyboardKeys.swift
//  MathPortal
//
//  Created by Petra Čačkov on 21/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Button {
    
    let keyName: ButtonType
    
    init(key: ButtonType) {
        self.keyName = key
    }
}
extension Button {
    enum ButtonType {
        case integer(value: Int)
        case letter(value: String)
        case plus
        case minus
        case back
        case forward
        case delete
        case brackets
        case indicator
        case done
        case levelOut
        case levelIn
        case fraction
        case root
        case exponent
        case index
        case indexAndExponent
        case logarithm

        static var integers: [ButtonType] = Array(0...9).map { .integer(value: $0) }
        static var letters: [ButtonType] = Array("abcdefghijklmnopqrstuvwxyz").map { .letter(value: String($0)) }
        
        var componentView: UIView? {
            switch self {
            case .fraction:
                guard let fraction: UIView = EquationView.generateFraction([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1)], color: UIColor.gray).view else { return EquationView.Nil.view}
                return fraction
            case .brackets:
                guard let brackets: UIView = EquationView.linearlyLayoutViews([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1)], type: .brackets, brackets: true, color: UIColor.gray, scale: 1).view else { return EquationView.Nil.view }
                return brackets
            case .root:
                guard let root: UIView = EquationView.generateRoot([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 0.5), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1)], color: UIColor.gray).view else { return EquationView.Nil.view}
                return root
            case .exponent:
                guard let exponent: UIView = EquationView.generateExponentAndIndex([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 0.7)], type: .exponent, color: UIColor.gray).view else { return EquationView.Nil.view }
                return exponent
            case .index:
                guard let index: UIView = EquationView.generateExponentAndIndex([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 0.7) ], type: .index, color: UIColor.gray).view else { return EquationView.Nil.view }
                return index
            case .indexAndExponent:
                guard let indexAndExponent: UIView = EquationView.generateExponentAndIndex([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 0.7) , EquationView.generateEmpty(squareColor: UIColor.gray, scale: 0.7) ], type: .indexAndExponent, color: UIColor.gray).view else { return EquationView.Nil.view }
                return indexAndExponent
            case .logarithm:
                guard let log: UIView = EquationView.generateFunction([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 0.7), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1)], color: UIColor.gray, type: .logarithm).view else { return EquationView.Nil.view}
                return log
            case .plus:
                guard let plus: UIView = EquationView.generateOperator( .plus, color: UIColor.gray).view else { return EquationView.Nil.view}
                return plus
            case .minus:
                guard let minus: UIView = EquationView.generateOperator( .minus, color: UIColor.gray).view else { return EquationView.Nil.view}
                return minus
            case .back:
                guard let back: UIView = EquationView.generateText(value: "<", color: UIColor.gray).view else { return EquationView.Nil.view }
                return back
            case .forward:
                guard let forward: UIView = EquationView.generateText(value: ">", color: UIColor.gray).view else { return EquationView.Nil.view }
                return forward
            case .delete:
                guard let delete: UIView = EquationView.generateText(value: "Delete", color: UIColor.gray).view else { return EquationView.Nil.view }
                return delete
            case .done:
                guard let done: UIView = EquationView.generateText(value: "Done", color: UIColor.gray).view else { return EquationView.Nil.view }
                return done
            case .integer(let value):
                guard let integer: UIView = EquationView.generateText(value: String(value), color: UIColor.gray).view else { return EquationView.Nil.view }
                return integer
            case .levelIn:
                guard let levelIn: UIView = EquationView.generateText(value: "In", color: UIColor.gray).view else { return EquationView.Nil.view }
                return levelIn
            case .levelOut:
                guard let levelOut: UIView = EquationView.generateText(value: "Out", color: UIColor.gray).view else { return EquationView.Nil.view }
                return levelOut
            case .indicator:
                break
            case .letter(let value):
                guard let letter: UIView = EquationView.generateText(value: value, color:  UIColor.gray).view else { return EquationView.Nil.view}
                return letter
            }
            return nil
        }
        
    }
}
