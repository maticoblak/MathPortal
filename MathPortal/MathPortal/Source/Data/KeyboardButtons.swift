//
//  KeyboardKeys.swift
//  MathPortal
//
//  Created by Petra Čačkov on 21/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit

class Keyboard {
    class Button {
        
        let keyName: Buttons
        let name: String
        let id: UUID
        
        let key: [String:Any]
        
        init(key: Buttons, UUID: UUID = UUID()) {
            self.keyName = key
            self.name = key.string
            self.id = UUID
            self.key = ["button":key.string, "id":id]
            
        }
    }
}
extension Keyboard {
    enum Buttons {
        case one
        case two
        case three
        case four
        case plus
        case minus
        case levelUpArrow
        case levelDownArrow
        case back
        case front
        case delete
        case rightBracket
        case leftBracket
        case brackets
        case indicator
        
        var string: String {
            switch self {
            case .one: return "1"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .plus: return "+"
            case .minus: return "-"
            case .levelUpArrow: return "▲"
            case .levelDownArrow: return "▼"
            case .back: return "<"
            case .front: return ">"
            case .delete: return "Delete"
            case .rightBracket: return ")"
            case .leftBracket: return "("
            case .brackets: return "()"
            case .indicator: return "|"
            }
        }
    }
}
