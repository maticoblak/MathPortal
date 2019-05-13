//
//  ExpressionTests.swift
//  MathPortalTests
//
//  Created by Petra Čačkov on 10/05/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import XCTest

private typealias Component = Equation.Component
private typealias Text = Equation.Text
private typealias Operator = Equation.Operator

private let plusOperator = Operator(.plus)
private let minusOperator = Operator(.minus)


class ExpressionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicEquation() {
        // This is an example of a performance test case.
        let equation = Equation()
        equation.expression.items.append(Equation.Text("1"))
        equation.expression.items.append(Equation.Operator(.plus))
        equation.expression.items.append(Equation.Text("2"))
        let view = equation.expression.generateView()
        XCTAssert(view != nil, "Could not generate view")
        XCTAssert(view!.bounds.width > 0.0, "View has zero width")
        XCTAssert(view!.bounds.height > 0.0, "View has zero height")
    }
    
    func testSum() {
        let equation = Equation()
        equation.expression.items.append(Equation.Text("1"))
        equation.expression.items.append(Equation.Operator(.plus))
        equation.expression.items.append(Equation.Text("2"))
        guard let result = equation.expression.computeResult() else { XCTFail("Could not generate result"); return }
        XCTAssert(result == 3.0, "1 + 2 = \(result)")
    }
    
    func testSubtraction() {
        let equation = Equation()
        equation.expression.items.append(Equation.Text("1"))
        equation.expression.items.append(Equation.Operator(.minus))
        equation.expression.items.append(Equation.Text("2"))
        guard let result = equation.expression.computeResult() else { XCTFail("Could not generate result"); return }
        XCTAssert(result == -1.0, "1 - 2 = \(result)")
    }
    
    func testChained() {
        let equation = Equation()
        equation.expression.items.append(Equation.Text("1"))
        equation.expression.items.append(Equation.Operator(.plus))
        equation.expression.items.append(Equation.Text("2"))
        equation.expression.items.append(Equation.Operator(.minus))
        equation.expression.items.append(Equation.Text("1.5"))
        guard let result = equation.expression.computeResult() else { XCTFail("Could not generate result"); return }
        XCTAssert(result == 1.5, "1 + 2 - 1.5 = \(result)")
    }
    
    func testOperatorStarts() {
        let equation = Equation()
        equation.expression.items.append(Equation.Operator(.plus))
        equation.expression.items.append(Equation.Text("2"))
        XCTAssert(equation.expression.computeResult() == nil, "Result should fail")
    }
    
    
    
    func testComponent() {
        let equation = Equation()
        equation.expression = .init(items: [
            Component(items: [Text("2"), plusOperator, Text("5")]),
            minusOperator,
            Component(items: [Text("1"), plusOperator, Text("-6")])
        ])
        guard let result = equation.expression.computeResult() else { XCTFail("Could not generate result"); return }
        XCTAssert(result == 12.0, "Incorrect result. Got \(result)")
    }

}
