//
//  Task.swift
//  MathPortal
//
//  Created by Petra Čačkov on 17/04/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import UIKit
import Parse

class Task: ParseObject {

    var name: String?
    var userId: String?
    var equations: [Equation]?
    
    // MARK: Sync
    
    override init() {
        super.init()
        userId = PFUser.current()?.objectId
    }
    override init?(pfObject: PFObject?) {
        super.init(pfObject: pfObject)
    }
    
    override class var entityName: String { return "Task" }
    
    override func generetePFObject() -> PFObject? {
        let item = super.generetePFObject()
        item?[Object.name.rawValue] = name
        item?[Object.userId.rawValue] = userId
        item?[Object.equations.rawValue] = equations?.map { equationToJson(equation: $0.expression) }
        return item
    }
    
    override func updateWithPFObject(_ object: PFObject) throws {
        try super.updateWithPFObject(object)
        guard let name = object[Object.name.rawValue] as? String, let userId = object[Object.userId.rawValue] as? String else {
            throw NSError(domain: "ParseObject", code: 400, userInfo: ["dev_message": "Could not parse Task data from PFObject"])
        }
        self.name = name
        self.userId = userId
        self.equations = (object[Object.equations.rawValue] as? [[String : Any]])?.map { Equation(expression: JSONToEquation(json: $0 )) }
    }

    static func generateQueryWithUserId(_ userId: String) -> PFQuery<PFObject>? {
        let query = generatePFQuery()
        query.whereKey(Object.userId.rawValue, equalTo: userId)
        return query
    }
    static func fetchUserTasks(userId: String, completion: ((_ objects: [Task]?, _ error: Error?) -> Void)?) {
        generateQueryWithUserId(userId)?.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            completion?(objects?.compactMap {Task(pfObject: $0) }, error)
        }
    }
    
    /* NOTE:
        - Exponent should always be checked before Index since exponent is subclass of Index
        - Fraction, Root, Index, Exponent, IndexAndExponent, Logarithm should alyas be checked before Component, since they are subclasses of component
    */
    private func equationToJson(equation: Equation.Expression) -> [String: Any] {
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
    
    private func JSONToEquation(json: [String : Any]?) -> Equation.Expression {
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

extension Task {
    enum Object: String {
        case name = "taskName"
        case userId = "userId"
        case equations = "equations"
    }
}
