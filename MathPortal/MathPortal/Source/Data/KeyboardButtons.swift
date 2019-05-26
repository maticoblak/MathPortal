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
    let name: String
    
    init(key: ButtonType) {
        self.keyName = key
        self.name = key.string
    }
}
extension Button {
    enum ButtonType {
        case integer(value: Int)
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
        
        static var integers: [ButtonType] = Array(0...9).map { .integer(value: $0) }
        
        
        var string: String {
            switch self {
            case .integer(let value): return String(value)
            case .plus: return "+"
            case .minus: return "-"
            case .back: return "<"
            case .forward: return ">"
            case .delete: return "Delete"
            case .brackets: return "()"
            case .indicator: return "|"
            case .done: return "Done"
            case .levelIn: return "In"
            case .levelOut: return "Out"
            case .fraction: return "a/b"
            }
        }
        var componentView: UIView? {
            switch self {
            case .fraction:
                guard let fraction: UIView = EquationView.generateFraction([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1), EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1)], color: UIColor.gray).view else { return EquationView.Nil.view}
                return fraction
            case .brackets:
                guard let brackets: UIView = EquationView.linearlyLayoutViews([EquationView.generateEmpty(squareColor: UIColor.gray, scale: 1)], brackets: true, color: UIColor.gray, scale: 1).view else { return EquationView.Nil.view }
                return brackets
            case .back, .indicator, .integer, .plus, .minus, .forward, .delete, .done, .levelIn, .levelOut:
                break
            }
            return nil
        }
        

//        func createFractionView() -> UIView {
//            var numerator: UILabel  {
//                let label = UILabel(frame: .zero)
//                label.text = "a"
//                label.textColor = UIColor.lightGray
//                label.sizeToFit()
//                return label
//            }
//            var denominator: UILabel  {
//                let label = UILabel(frame: .zero)
//                label.text = "b"
//                label.textColor = UIColor.lightGray
//                label.sizeToFit()
//                return label
//            }
//            var fractionLine: UIView {
//                let line = UIView(frame: .zero)
//                line.frame.size = CGSize(width: max(numerator.bounds.width, denominator.bounds.width) + 3, height: 1.5  )
//
//                line.backgroundColor = UIColor.lightGray
//                return line
//            }
//
//            let views = [numerator, fractionLine, denominator]
//            let width: CGFloat = fractionLine.frame.width
//
//            let fractionView: UIView = UIView(frame: .zero)
//
//            var y: CGFloat = 0.0
//            views.forEach { item in
//                item.center.x = width / 2
//                item.frame.origin.y = y
//
//                fractionView.addSubview(item)
//
//                y += item.bounds.height
//            }
//
//            fractionView.frame = CGRect(x: 0, y: 0, width: width, height: y)
//            return fractionView
//        }
    }
}
