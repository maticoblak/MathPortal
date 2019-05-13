//
//  IndicatorTests.swift
//  MathPortalTests
//
//  Created by Petra Čačkov on 10/05/2019.
//  Copyright © 2019 Petra Čačkov. All rights reserved.
//

import XCTest

class IndicatorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasic() {
        let equation = Equation()
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 1))
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 2))
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 3))
        equation.handelMathKeyboardButtonsPressed(button: .plus)
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 2))
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 3))
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 4))
        guard let result = equation.computeResult() else { XCTFail("Could not generate result"); return }
        XCTAssert(result == 357.0, "Incorrect result. Got \(result)")
    }
    
    func testMovement() {
        let equation = Equation()
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 5))
        equation.handelMathKeyboardButtonsPressed(button: .plus)
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 1))
        equation.handelMathKeyboardButtonsPressed(button: .back)
        equation.handelMathKeyboardButtonsPressed(button: .integer(value: 2))
        guard let result = equation.computeResult() else { XCTFail("Could not generate result"); return }
        XCTAssert(result == 26.0, "Incorrect result. Got \(result)")
    }

}
