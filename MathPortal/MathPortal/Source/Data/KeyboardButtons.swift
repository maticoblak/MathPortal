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
        case rightBracket
        case leftBracket
        case brackets
        case indicator
        case done
        case levelOut
        case levelIn
        
        static var integers: [ButtonType] = Array(0...9).map { .integer(value: $0) }
        
        var string: String {
            switch self {
            case .integer(let value): return String(value)
            case .plus: return "+"
            case .minus: return "-"
            case .back: return "<"
            case .forward: return ">"
            case .delete: return "Delete"
            case .rightBracket: return ")"
            case .leftBracket: return "("
            case .brackets: return "()"
            case .indicator: return "|"
            case .done: return "Done"
            case .levelIn: return "In"
            case .levelOut: return "Out"
            }
        }
    }
}
